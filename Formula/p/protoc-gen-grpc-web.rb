class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.2.tar.gz"
  sha256 "0f0c8c0c1104306d67dad678be7c14efe52a698795a58b2b72ab67a8bb100c15"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7c7fa3e703cb3a73a2c40eae79eb32d5192b34eb77ff931350337fe860375a9"
    sha256 cellar: :any,                 arm64_sequoia: "7a083a9a7ae60994a3898f7dc61375dbf8a5705b12e7ae7be392de584ed90832"
    sha256 cellar: :any,                 arm64_sonoma:  "adce43fdc5a56ab4592bbe6c0959a624f215eebbcfed219c1b4fd19c68230062"
    sha256 cellar: :any,                 sonoma:        "1d7475acee08122debcf4ae8d514892bf606e0392bb806b7f969f60f80149627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f59db0212739c4b8c98474e2fb642ade70042f7003c43cbdb4666970665164bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2da89855c161c0bcb2d39ea2fa33a75ad5bc21deadf05da95dcfb7714d631a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf@29"
  depends_on "protoc-gen-js"

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
    protoc = Formula["protobuf@29"].bin/"protoc"
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
