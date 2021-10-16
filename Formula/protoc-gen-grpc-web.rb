require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.3.0.tar.gz"
  sha256 "6ba86d2833ad0ed5e98308790bea4ad81214e1f4fc8838fe34c2e5ee053b73e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8625843e386cf1aec90d4f750ad1480586f10e90fa5f8d2092037b92583379d3"
    sha256 cellar: :any,                 big_sur:       "c706a6449039679963254536a30511f031fe11705ac36ed5d2f3ab2fd83a2aba"
    sha256 cellar: :any,                 catalina:      "3917c4c2ff273a01472cd46265b5d12a6df0012e721cb271f4c512a894e3ccd5"
    sha256 cellar: :any,                 mojave:        "b4486c699cd657005acd262ef592784f3bbf3b50408e90d2a84d42dcb5205853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f57d007f37bd720b813f7254d32c6683257de8c1afe95a93f3dc23c9641c093"
  end

  depends_on "cmake" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "protobuf"

  def install
    bin.mkpath
    system "make", "install-plugin", "PREFIX=#{prefix}"
  end

  test do
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
