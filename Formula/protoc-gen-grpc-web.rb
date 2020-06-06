require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.1.0.tar.gz"
  sha256 "a8a200bb4dbbbb0b3fe126c9f1f8276909d870fb641a83a3b722eed0c57c3d57"

  bottle do
    cellar :any
    sha256 "9ea8d0854a7150369ef456888b09e06a3eccb8000292e32c85a791923b29dae9" => :catalina
    sha256 "e726aaefde24e772f4063778399f8d12e286361c3413e22d04c642ca89a1acc6" => :mojave
    sha256 "6804424f4eb74a1a9aa4173c03e33ee471d5b40f32890322faa10d2a914c8160" => :high_sierra
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
