require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.4.1.tar.gz"
  sha256 "1b4d9ffdf8e12eda361107d901fe7ba269d12e9dab97fe97c6b1e03847efd4f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0587fc3aabc068843d2b601ebad74edf5779855603e1fea8d4b78b8974551696"
    sha256 cellar: :any,                 arm64_big_sur:  "9bcf871e1da065a5a9c86d8b748701a296d2c5188f80d301f9f8ea6a6ed3a50a"
    sha256 cellar: :any,                 monterey:       "de0f2a8876ad8d2d95e7a19efbd19bf8c147bebd643815839ff7e4b2684fbf0c"
    sha256 cellar: :any,                 big_sur:        "b2d4399826e54859bf00219c04afb021f8b6ec4ce2bf06d29e37f6fc7623ef7e"
    sha256 cellar: :any,                 catalina:       "052accf3563010aad3848ad7b0d4a7c55b44ef1e2de34453eb6abf1eaa7b169b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de39b8cb717fa5ebfb1fd591049a28e6677b9d172c3f9542afc1557ad66a60e9"
  end

  depends_on "cmake" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "protobuf@3"

  def install
    bin.mkpath
    system "make", "install-plugin", "PREFIX=#{prefix}"

    # Remove these two lines when this formula depends on unversioned `protobuf`.
    libexec.install bin/"protoc-gen-grpc-web"
    (bin/"protoc-gen-grpc-web").write_env_script libexec/"protoc-gen-grpc-web",
                                                 PATH: "#{Formula["protobuf@3"].opt_bin}:${PATH}"
  end

  test do
    ENV.prepend_path "PATH", Formula["protobuf@3"].opt_bin

    # First use the plugin to generate the files.
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
      message TestResult {
        bool passed = 1;
      }
      service TestService {
        rpc RunTest(Test) returns (TestResult);
      }
    EOS
    (testpath/"test.proto").write testdata
    system "protoc", "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                     "--js_out=import_style=commonjs:.",
                     "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    testts = <<~EOS
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    EOS
    (testpath/"test.ts").write testts
    system "npm", "install", *Language::Node.local_npm_install_args, "grpc-web", "@types/google-protobuf"
    # Specify including lib for `tsc` since `es6` is required for `@types/google-protobuf`.
    system "tsc", "--lib", "es6", "test.ts"
  end
end
