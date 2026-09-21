class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://grpc.io"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.1.1.tar.gz"
  sha256 "7766763275c6bf99115c9b535aaa3c507566847d47ea72a1f70da7fe427a98d3"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b480d8c9ac120c8d3ab6dcf16f710e81fa4b115315d4f62a23bc83a450d7134"
    sha256 cellar: :any, arm64_tahoe:       "c5a5f47de93304b3ff6bc9e2984050d9b77b8dd3b57a95e37829d5ea1f755087"
    sha256 cellar: :any, arm64_sequoia:     "7634c36aeb6a590b8a15bbd7d470db5536371f2b08e3822588ea17d228ca080a"
    sha256 cellar: :any, arm64_linux:       "d9f05205809785a209a69a1b26cac5c5ea4ab20f833655dd227b6ec24a9f91b7"
    sha256 cellar: :any, x86_64_linux:      "f9461b2657bf5e50f18c49ec50ef91a6b32a3a291645fb42e73a73cfbabf8c77"
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
    protoc = formula_opt_bin("protobuf")/"protoc"
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
