class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.82.1.tar.gz"
  sha256 "5b0b193657e0e4c38ff37133d7710c020e595cce5e8aadfbc7410eee11ebdb8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2a3d37e2249c29f0482bcbeaa33c619f2041ec7131afe42b415b155166ed1838"
    sha256 cellar: :any, arm64_sequoia: "666be615dde2a1e08c555f145e503e174b40dc7681c4298543fa036832dcf28c"
    sha256 cellar: :any, arm64_sonoma:  "6aff87bfbfb89b21747b305057d05cf0b259fed3bff33fdb010fa2e27f885d90"
    sha256 cellar: :any, sonoma:        "f9784aefcf42ed85e5215dc8028deb4d7eede1149d4dac3bb864bc9b498afe7a"
    sha256 cellar: :any, arm64_linux:   "56c52b3dabe4da8fa23951ed78e11b7d184e258bf5f97cd4e680127ea0572863"
    sha256 cellar: :any, x86_64_linux:  "82998bb92bb19323d649c5528fffb01c52bff143de24139a0cfe7e027e94ec5b"
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
