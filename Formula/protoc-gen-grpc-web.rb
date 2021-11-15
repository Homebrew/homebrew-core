require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.3.0.tar.gz"
  sha256 "6ba86d2833ad0ed5e98308790bea4ad81214e1f4fc8838fe34c2e5ee053b73e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd5787730c11925a5631829a46ea8e691f3b60d8260625f8e5ce4f492fc3a61f"
    sha256 cellar: :any,                 arm64_big_sur:  "2da48dc258aef815fe598868ff75acf4f123b232aace297eaaf5fda0d1b564f0"
    sha256 cellar: :any,                 monterey:       "ba88fc45253b9d7a1e126f5f96ce3e016b2ec62f109391bbd43f43ea4914a835"
    sha256 cellar: :any,                 big_sur:        "d4938bcd3c7efd330b9d13be4e3e7db2525b4bec8571e8d8b843c6c6d3fd40af"
    sha256 cellar: :any,                 catalina:       "ec20d43ded4c5b202a4d245e239d4cc1d8fc50aad459534f5e882fb9cf184119"
    sha256 cellar: :any,                 mojave:         "e234dcb68737d09bd4e73271e1efb8284078bd60770fc6711319be342e966672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a13ee2791266209e25e607fd578303cd5ccc30d7da5156f1f6573ef34c20fa6"
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
