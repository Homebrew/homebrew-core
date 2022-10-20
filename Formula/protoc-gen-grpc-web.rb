require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.4.1.tar.gz"
  sha256 "1b4d9ffdf8e12eda361107d901fe7ba269d12e9dab97fe97c6b1e03847efd4f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a4419dc20745e0be397694a0181282c8838f821f535fef33b115e63f37a1a69f"
    sha256 cellar: :any,                 arm64_big_sur:  "7f1c93ce611e0868db6ef7751022e53a81293034b425922c1cb9cf078729b664"
    sha256 cellar: :any,                 monterey:       "e4babfc501a777bc4aa343efa55d538b3a70f7ed6e9e937fae0c2f09207e22be"
    sha256 cellar: :any,                 big_sur:        "503597cdbf99f5174d92e631a2479f6bc103c09f7f47dd0bcb92c31242106bdb"
    sha256 cellar: :any,                 catalina:       "c810fa95ab9f773a1902e4fba0a045b7de6c349104844014b9cf933d7e6d11b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade0d016857930b12fc4483f980a71352c3f4e072c6e074a7027af392800d24f"
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
