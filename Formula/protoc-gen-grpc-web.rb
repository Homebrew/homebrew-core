require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/1.4.0.tar.gz"
  sha256 "92555e27fb51b3fda0dac6957d448ee19f88ef90392da62253e9523b76daf80b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5328893bcbe0358cf13cd9271930f43f84133876b3af516fd05ed56d2abe907"
    sha256 cellar: :any,                 arm64_big_sur:  "c58d3cce1fae0841e43f388a4882c8c1f0a2ce6dadc8d602c3868de812919041"
    sha256 cellar: :any,                 monterey:       "b2c76d8ecbe7fd209f8ce81ca5df924b4cb42cb30fb8bbbda1ad969cfbec5eaf"
    sha256 cellar: :any,                 big_sur:        "8be0ebdbcc638da05576db96c7e250f37cb76652d49e5f914dc0acd9fab6c99e"
    sha256 cellar: :any,                 catalina:       "6b9587aa8e753496fb131bddbfe34c034b59daffe48f58ba3108873cde26b034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22f91d1442b02b6d546eaa5a10675221d01cf457bb9a408c574dfdfc67825ed"
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
