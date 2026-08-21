class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.83.1.tar.gz"
  sha256 "0a110b4565bae8fddc646bb731e733331819d2cf89017764aa68b15495297b81"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47dd78479a1ee94c991b77c35a0fd693aadd3248a661608da6e0328a5d39eb26"
    sha256 cellar: :any, arm64_sequoia: "eb7c461e007011e863f2a24c98bcc9e061cc18fac5ff136fe100ba29b28d8c1f"
    sha256 cellar: :any, arm64_sonoma:  "3e43da3abf3254cb0ca716c30c58258ed00bb3e40781bdf7de1740b73ff65966"
    sha256 cellar: :any, sonoma:        "6b7c2b27194f9b5b6d08af0b9e068e915c8be9954f91ea67577794387fbdab9b"
    sha256 cellar: :any, arm64_linux:   "6fce723fd1173bd19368de827c148d66306b088555b8c8ee9e1a7cc2253e81b8"
    sha256 cellar: :any, x86_64_linux:  "5ec8abdebdd52678c39e536375eea80197a033c9befae7f2fc613f5e44dd2db0"
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
