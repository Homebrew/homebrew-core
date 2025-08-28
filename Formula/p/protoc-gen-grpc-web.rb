class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.0.tar.gz"
  sha256 "bcf1a75904b14ce40ac003dea901852412d0ed818af799e403e3da15a6528b29"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b1a3aeb4981b83ae2d2d8c96f51c2eb2e20e2331947e9b500e666fd80891a23"
    sha256 cellar: :any,                 arm64_sonoma:  "5aa6a3cb6d4565c364468bf463e9ff126acef3a0c63e80ff06b531d7f8830d29"
    sha256 cellar: :any,                 arm64_ventura: "c310b2c732975da8c97d1e919da10b06e22dc0f38d280260bb862886e27931b3"
    sha256 cellar: :any,                 sonoma:        "a22d2a308d4460b74970a9a28296c28426d720fbe62a0cf3137efce0c2602780"
    sha256 cellar: :any,                 ventura:       "475250498891ff94b8c0802304a65811bdf0dd39f9514126f52c34d1d7a314e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1bcc099c3ff809b64ae43cf3678d08bdcb639ad72e5aa8ae88375097dfb2811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a5bfa67e0a822a1c177289021140df0b7f12b341c8428818178b23c26324f9"
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
