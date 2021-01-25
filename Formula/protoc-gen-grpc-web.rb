require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.2.1.tar.gz"
  sha256 "23cf98fbcb69743b8ba036728b56dfafb9e16b887a9735c12eafa7669862ec7b"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "0ad66a3cf6e5132dc51920722e2213f50ebc57c843d7120dd07636896ac09a03" => :big_sur
    sha256 "ab78bbc2a63768bd68930eccdb773a18d77a456f84162f5d14260a67e4df333c" => :arm64_big_sur
    sha256 "26bc7c5c83a68b2fdd4b031807b410bffc9ce03619a0b75e228ddbcd058c467e" => :catalina
    sha256 "b8b91ccdca4ea4d0014ea5ef890391c1e3ec88d10f1abcfa04cb0fabd99733c9" => :mojave
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
