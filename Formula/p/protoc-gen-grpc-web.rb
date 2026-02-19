class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.2.tar.gz"
  sha256 "0f0c8c0c1104306d67dad678be7c14efe52a698795a58b2b72ab67a8bb100c15"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9af493e95682f631439158b401f97298ce962cb800b7b9124669c771f4a8765d"
    sha256 cellar: :any,                 arm64_sequoia: "eb6bb14dcfe3c1aa89abfdbb933c09f33626c2b6b4c5de5666986692e6364cc1"
    sha256 cellar: :any,                 arm64_sonoma:  "b8856c973c1d821803a2616b22275f4c94b5ae4bb3390990e53044fad0a063b4"
    sha256 cellar: :any,                 sonoma:        "ec9590373e9414070067925b83954e9920957c631ff740478eeb14775d9b9776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b32d54f7a13da54578aa4fea781eeb4981343354d839caa42fe5ccaa1722d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78f69a6baf9b44939f78c40f7b73ea85de1a4fd87f0cddd7f5958eb494fbd70"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
  depends_on "protoc-gen-js"

  # Workaround to build with Protobuf 30+. Issue ref: https://github.com/grpc/grpc-web/issues/1522
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/d0b7cf85a11a9acfa1a422305948dff6621bbda9/Patches/protoc-gen-grpc-web/protobuf-30.diff"
    sha256 "9c7e0ddf5ba68c179e7b8edc2c48de5b9b9d4801a6c8fd93ee199e27291aeebd"
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
