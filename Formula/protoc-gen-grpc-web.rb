require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.3.1.tar.gz"
  sha256 "d292df306b269ebf83fb53a349bbec61c07de4d628bd6a02d75ad3bd2f295574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "694f70b69029f55a659d0981473b025467dc9f88ec84195f6b88d6ca2d67c3cf"
    sha256 cellar: :any,                 arm64_big_sur:  "b8c378b553e2ac95659369ada0af31198ef30e72391c3ac867faa999be965ede"
    sha256 cellar: :any,                 monterey:       "25779d4c29e4c1f8299db7ada86e4d568cd8d6a5ce8bbce2956d1f6a2785e347"
    sha256 cellar: :any,                 big_sur:        "f4ffae6839a5a559e198d61c79bc567a714fa0fc884f0f6f031ebd9c78c83115"
    sha256 cellar: :any,                 catalina:       "7480b35d0d8e6e280da6824c70a8e0c58308a51511f4010fdf2c165f1d8e14ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae7d825f02135ab092f592229bea5a3d0dff5ae02374bebb3ff6920efcd9b7f0"
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
