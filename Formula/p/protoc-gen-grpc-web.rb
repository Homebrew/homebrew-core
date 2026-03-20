class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.2.tar.gz"
  sha256 "0f0c8c0c1104306d67dad678be7c14efe52a698795a58b2b72ab67a8bb100c15"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01e1a6986e6d6270ce5ed29e94d619285fcecb7334d35a216cde210e18191d84"
    sha256 cellar: :any,                 arm64_sequoia: "c8bf0dab8dcc53e13b636e99164b0f6b878eaa47c0672337435be9fd06138d87"
    sha256 cellar: :any,                 arm64_sonoma:  "498a819a0a45f7b0358aa6ceb20d8a063a0a5e8189c7c41b1b37393715322582"
    sha256 cellar: :any,                 sonoma:        "7f136a33bda68450cd1e5bf62f0a6a8687cbeaf3eda428f7c1c2cadb535267ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea14c30f166c04e7682aae5b679ce641a219b1d2418a742a71e6b0508906d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e344960398e594495b8a0e3c5d656c518bf0104bbc1b73053da903480358e7b5"
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
