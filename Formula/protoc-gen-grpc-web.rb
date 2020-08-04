require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.2.0.tar.gz"
  sha256 "8d9b1e9b839a5254aa79cb4068b05fdb6e1de5637c1b8551f95144159a4801f2"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "6f73cc972d706c31d5f5a18aad3f7a0cc8568b2804dd9c713eed59bebb69aa39" => :catalina
    sha256 "296f7f6501fef507feb8e54243221cfa4212c90149efa11afcbccd1ba2b417a3" => :mojave
    sha256 "244fbadefd710b79f73f32fa08680053833d651e8ee57c924f6913f9f06f91d0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "protobuf"

  def install
    bin.mkpath
    inreplace "javascript/net/grpc/web/Makefile", "/usr/local/bin/", "#{bin}/"
    system "make", "install-plugin"
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
    system "tsc", "test.ts"
  end
end
