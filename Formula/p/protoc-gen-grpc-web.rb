class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://grpc.io"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.2.tar.gz"
  sha256 "0f0c8c0c1104306d67dad678be7c14efe52a698795a58b2b72ab67a8bb100c15"
  license "Apache-2.0"
  revision 6

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c631d0ad25f903f8cb8e91a37edd017cf195fe4c2726f05067d6578198543d6"
    sha256 cellar: :any, arm64_sequoia: "e330c3e95cffbecd62f20b302e418c815329f33bafe6b1ddc8591c87e7c036cc"
    sha256 cellar: :any, arm64_sonoma:  "3fe9bb2b2d8b8421fdebfbb1d2b297189ba99c658ada569554859fe2651d11ac"
    sha256 cellar: :any, sonoma:        "4aa6d2b9dd9dcc5f5ea1962e2ce7d1d18729639702e1d3890ff4e333f3d7826b"
    sha256 cellar: :any, arm64_linux:   "f75da1d59baf3fdb3354b13606544ab4b5f93454dce242fb0904449264a06d1d"
    sha256 cellar: :any, x86_64_linux:  "589e1d374217322d70be03f32c8fb102e1a072a0de98a4679836186fe965a3f7"
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
