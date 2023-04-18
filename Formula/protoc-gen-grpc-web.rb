require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.4.2.tar.gz"
  sha256 "376937b22095bdbea00f8bcd9442c1824419a99cbc37caf0967e4a0fa8b16658"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "54e59010fc995ac571f6c76369721c28dad336723404e858cce02e893db30e61"
    sha256 cellar: :any,                 arm64_monterey: "b7ad14af33ee7f73663972c1ceb97727bc0fea026c1e4c16ba2913272208578d"
    sha256 cellar: :any,                 arm64_big_sur:  "9d8551246e95b74f03875968666431ed0a5b9db6282c752ed49e106eb5e70034"
    sha256 cellar: :any,                 ventura:        "70b8eac814308965112d0101ab8033ad5897c4e3c509ee9c9755583a0bccb55b"
    sha256 cellar: :any,                 monterey:       "f5435c6bc4f25d62a67d56904a593640ddf4a7c868e8255f9d86620693a34873"
    sha256 cellar: :any,                 big_sur:        "52b8503b1b9053fc90043c83d7d3b86767a97616955b89841f4d59ab6269daa8"
    sha256 cellar: :any,                 catalina:       "b839a0129eca03ab237945ff1a81249b860bb3421814dc42ca52132cb5303ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f9dcef9a241e6104e446900dc34fc9daafa8bc38886d3ba55cbf49b1f66cd4"
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
