class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://grpc.io"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.2.tar.gz"
  sha256 "0f0c8c0c1104306d67dad678be7c14efe52a698795a58b2b72ab67a8bb100c15"
  license "Apache-2.0"
  revision 9

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb1ea0cbd1f5cff8d0c6ef36c14fecec78d910c5f8ee0dff419c9a48d9650e0a"
    sha256 cellar: :any, arm64_sequoia: "e3853c17bfa39b10441796202ea30839d3c50776b1a45c8606ed796ff0a0e644"
    sha256 cellar: :any, arm64_sonoma:  "0113c9e2fa771628facbe7a9fea2855c5176c2f60e822dc143ebe437ecdd6076"
    sha256 cellar: :any, sonoma:        "ea1c84f39d7ea88e48e082c0d0b43c29d75269673bc659f7ea305f05a1b97a11"
    sha256 cellar: :any, arm64_linux:   "152465906fafeefd7aa3251118ddf81151cac50f1b517013a45d4cfbeb4bdf23"
    sha256 cellar: :any, x86_64_linux:  "31f88eeadc6f0bc3fa5ba02b8b5b0ef63ee8825e91a0b37eb523d72cda80b382"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
  depends_on "protoc-gen-js"

  # Workaround to build with Protobuf 30+.
  patch do
    file "Patches/protoc-gen-grpc-web/protobuf-30.diff"
    type :unofficial
    resolves "https://github.com/grpc/grpc-web/issues/1522"
  end

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp
    inreplace "javascript/net/grpc/web/generator/Makefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    (testpath/"test.proto").write <<~PROTO
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
    PROTO
    protoc = Formula["protobuf"].bin/"protoc"
    system protoc, "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                   "--js_out=import_style=commonjs:.",
                   "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    (testpath/"test.ts").write <<~TYPESCRIPT
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    TYPESCRIPT
    system "npm", "install", *std_npm_args(prefix: false), "grpc-web", "@types/google-protobuf"
    # Include DOM for AbortSignal used by grpc-web 2.x typings; ES level also satisfies @types/google-protobuf.
    system "tsc", "--lib", "es2021,dom", "test.ts"
  end
end
