class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "0c602853d2170c7104c767849935851baaf5a2c551ef0add040319ac3afe9bfc"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31c5ee2e83a22bd5ed837c3ea91441cb70b1a757ebb9f36a73fe27c26938cd31"
    sha256 cellar: :any,                 arm64_sonoma:  "96b40957bc9bd6baf2ff14fddd586d1ac53b163d0ff4dcfe6b5861a49b3cba08"
    sha256 cellar: :any,                 arm64_ventura: "808edf29d862c8629b134fe4f3c4bf5dec67eb18d35db9089b877c1921d495fb"
    sha256 cellar: :any,                 sonoma:        "87cf289e0a1021f8fd3ab582f06d4fe4ea1ea2e3a6aab05c9f036aed6eeb3f24"
    sha256 cellar: :any,                 ventura:       "a50f4af6414f11670c7858916b7e73297e8598a1b1746d9c75ef84763a2ce0ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8d49ae404a0a5b8d5f43d9b14c65ed4f667d7569d80716a33cf57774fc67fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc4c4c14f985d0cff23828325809846b3b26a4210b55a60981866a0c1f55a1f"
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
      s.gsub! '"-Wl,-Bstatic"', "\"-L#{Formula["protobuf"].opt_lib}\""
      s.gsub! ', "-static-libgcc"', ""
    end

    system "gradle", "--no-daemon",
                     "--stacktrace",
                     "--debug",
                     "--project-dir=compiler",
                     "-PskipAndroid=true",
                     "java_pluginExecutable"
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
