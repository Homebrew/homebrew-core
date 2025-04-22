class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "524a3d687f06ffd1c6ab66dbbb5de5b9f6adaa662570aa56e553d86c2065eb31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a280f76a988ef5687ffa6eb223727986ab2cf513cc051a608978c6df0270ef76"
    sha256 cellar: :any,                 arm64_sonoma:  "fca9edd4960cf6b741e710392c0150231a5c4dd57d044838b55baf6a885e6c2f"
    sha256 cellar: :any,                 arm64_ventura: "472759f812aa8ce1cc1ddbb6c5f6fe0a1bffb7bda96c59e1580d07ce615fa711"
    sha256 cellar: :any,                 sonoma:        "3ea86eefaf5d7940610044a2b3f2e459c2c1d0d0a3859e317120eaefaa67f190"
    sha256 cellar: :any,                 ventura:       "03a5350317cc75ebf19ba4cbef9333351bf6016bff7482ae02a652361c9d269d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c28a8f3f8b7ba9af498ec433e6305639cb5a040cead45e2dad89ec47c591059f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de2038322100e5f877a675a79d24d00d669b4347fdde6f5724325da2669eac0"
  end

  depends_on "gradle" => :build
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

    system "gradle", "--no-daemon", "--project-dir=compiler", "-PskipAndroid=true", "java_pluginExecutable"
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
