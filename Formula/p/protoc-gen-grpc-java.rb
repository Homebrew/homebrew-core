class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.82.2.tar.gz"
  sha256 "a8aa94f9df771ff5428f5cf8a5dc0fcd2ebb8fda85b29db84a4c7d8ca2153d5a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e208c80274f980c62d56159a1469d094b9876326913ff4d24565cc1f27beaf81"
    sha256 cellar: :any, arm64_sequoia: "6de01b7bb1c8756e5523dd468a8654386717be3f9415d35329202d0111cbbfa5"
    sha256 cellar: :any, arm64_sonoma:  "f312e7c5bce0a857e3d9b621310c4d98e2d817a60486a658c3f934e39d3b564b"
    sha256 cellar: :any, sonoma:        "13e0b4f756125c4dc7c6c2826a80db3dd1559a11b6bbb233163df102d4efc9ae"
    sha256 cellar: :any, arm64_linux:   "39c9d2e1350f3bf16c4ae79d40cb90e18c17f5d2d7b1aac108a1174323b7214a"
    sha256 cellar: :any, x86_64_linux:  "2a224912ea5ec8c3dee660429f9a265eefc38812fdb89f5b96a6ce4b4be542c2"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    # Workaround for newer Protobuf to link to Abseil libraries
    # Ref: https://github.com/grpc/grpc-java/issues/11475
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CXXFLAGS", Utils.safe_popen_read("pkgconf", "--cflags", "protobuf").chomp
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp

    inreplace "compiler/build.gradle" do |s|
      # Avoid build errors on ARM macOS from old minimum macOS deployment
      s.gsub! '"-mmacosx-version-min=10.7",', ""
      # Avoid static linkage on Linux
      s.gsub! '"-Wl,-Bstatic"', "\"-L#{formula_opt_lib("protobuf")}\""
      s.gsub! ', "-static-libgcc"', ""
    end

    args = %w[--no-daemon --project-dir=compiler -PskipAndroid=true]
    # Show extra logs for failures other than slow Intel macOS
    args += %w[--stacktrace --debug] if !OS.mac? || !Hardware::CPU.intel?

    system "gradle", *args, "java_pluginExecutable"
    bin.install "compiler/build/exe/java_plugin/protoc-gen-grpc-java"

    pkgshare.install "examples/src/main/proto/helloworld.proto"
  end

  test do
    system Formula["protobuf"].bin/"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath/"io/grpc/examples/helloworld/GreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end
