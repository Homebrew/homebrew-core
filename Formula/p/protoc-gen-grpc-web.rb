require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b89aa0ba6730eaad8968e03c7cdabdc8de90f56f841bebb0ba8d72d1753065ee"
    sha256 cellar: :any,                 arm64_ventura:  "b473d8ad0f6cafd1332fae6a53f19d4b1e9d1bd18e474610d954e63bdec13a66"
    sha256 cellar: :any,                 arm64_monterey: "17d9fb48ecfd5d783335352b4c4542f33b2030a0ddc28a8c97cf25129453c112"
    sha256 cellar: :any,                 sonoma:         "c889676f319943872be69fb44187852f9d2e16ddde51587ab5bf73e93b158ca3"
    sha256 cellar: :any,                 ventura:        "e891721d95f76ea73be1cbcae6707ea6bf8b404668f5760d34c5db0ae074fe29"
    sha256 cellar: :any,                 monterey:       "3f34b457d37d16e122b65bc2941432470cb45b0598f5ea8226fad6e1cd1ce3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "066c224c130c3a628c49551eac976a0bd4eea89314bc9195b31b13d3892f1160"
  end

  depends_on "cmake" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "protobuf@21"
  depends_on "protoc-gen-js"

  def install
    bin.mkpath
    system "make", "install-plugin", "PREFIX=#{prefix}"

    # Remove these two lines when this formula depends on unversioned `protobuf`.
    libexec.install bin/"protoc-gen-grpc-web"
    (bin/"protoc-gen-grpc-web").write_env_script libexec/"protoc-gen-grpc-web",
                                                 PATH: "#{Formula["protobuf@21"].opt_bin}:${PATH}"
  end

  test do
    ENV.prepend_path "PATH", Formula["protobuf@21"].opt_bin

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
