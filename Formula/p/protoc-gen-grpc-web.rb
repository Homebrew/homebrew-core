require "language/node"

class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ab0ae27b604ea0dbec2c4b3148a4fca8d53f0010ce9f1dd566bb22fcafc24f0"
    sha256 cellar: :any,                 arm64_ventura:  "ba446addb28734a91b4236a52dd8b17e9be933d90bd0bd6a1eac37368f64e023"
    sha256 cellar: :any,                 arm64_monterey: "57a3d2185dc31f48a53ef3ce0f3ec32fc3fcc22d72774a2cb1f1cbb4ba38e278"
    sha256 cellar: :any,                 sonoma:         "b4d8f1ba3299e952a09e5822df7dcf1571a731899e74198bad7810afdd9b8ab4"
    sha256 cellar: :any,                 ventura:        "7afe339c30a097798f4863d24e5dbac7452ea85c918651478ba3bfc7fe2680b3"
    sha256 cellar: :any,                 monterey:       "50076fd59b916ccc38cec5b4b7f0b1c43bc902aa47a2e12175b6efec80217984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cb5155debaa31e15a2f385298a09aca0f6041d7da2bc2612c73ad7deb33e80"
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
