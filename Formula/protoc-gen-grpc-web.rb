require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.2.1.tar.gz"
  sha256 "23cf98fbcb69743b8ba036728b56dfafb9e16b887a9735c12eafa7669862ec7b"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3a06983b33af29bf78f9a9d655dafb103b1ca4917e1a0a4f25cb2b79eb522e1"
    sha256 cellar: :any, big_sur:       "fda7d681b8dcde15ab4056e8aadd4cb554073b68bc0cacd0b40b93fb8876a2a5"
    sha256 cellar: :any, catalina:      "c2c56a4c0bcc4d157b9692d78fe811c7610e5f28cc3354085556ec8789410125"
    sha256 cellar: :any, mojave:        "21ee4f2d07a6c7e12c4b2ee96bc51edeb51f881af1de60ed8cc00a8f6cedcf71"
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
