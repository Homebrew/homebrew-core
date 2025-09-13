class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/2.0.1.tar.gz"
  sha256 "6f0686ec88bafb84ae82a96ecbe2c1373caaf2b06899d9be7205febd00022986"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4b85628f6c4a0c1d58d0eeffb6802b3a6163c87cb525cebdd7812491b6eec9b"
    sha256 cellar: :any,                 arm64_sonoma:  "271541e8add10cc2eea591b99ee7dd991045960e7178c42ba4df0355e84ecdef"
    sha256 cellar: :any,                 arm64_ventura: "fce11d6556f8d58e432d68bb83e4ca022208d37418a94ef663f5ea0f5c3d63d8"
    sha256 cellar: :any,                 sonoma:        "a32a250d7d72859f0d4ec63db063e28aad81ea8fcdbaaa4dd41cc854d4d34216"
    sha256 cellar: :any,                 ventura:       "ec0879da589c63d60270337c0cbbd21ffebb41635e05bd472283952857d1df25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6ba2371d9f3995f80859059f359476fe6c7bbd19303f530b44b37069f11458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f3bd286746e870752bbd29c0f30b49372388ccfbfd15376a50b135fbfc54812"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
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
