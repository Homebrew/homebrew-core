require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.3.1.tar.gz"
  sha256 "d292df306b269ebf83fb53a349bbec61c07de4d628bd6a02d75ad3bd2f295574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e679f48db0744502049cda46308f89de294134b522ba731fcfc88486589e992d"
    sha256 cellar: :any,                 arm64_big_sur:  "fcf29b351eb68c7db6dbe314dd819bd5f89909e46135008745362e345934d898"
    sha256 cellar: :any,                 monterey:       "0834212bc2e4be2c88985582ba06b15481cbd0fe2b8da2f1543c69089f64b5dd"
    sha256 cellar: :any,                 big_sur:        "e93c341c55c974b7be14075b248a1cac4722b3371ddd46dd5a1656e1ea5d817e"
    sha256 cellar: :any,                 catalina:       "4e46ddd1da2a1d3ddd2081ab8870b8cf813bf099b48a7a000e4bf8e524b3d748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c1d8d62acd218135d6cee0bfdfa0962604121cfcd3b42c6c56d0edb14b49c7"
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
