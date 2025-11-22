class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "58d8ad6c798a9a48e48381d0c72f0ccc2b94963e1a7db8c44d8f775042685b0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f65f8c4976e5f7237eb79a762ad073d9c33b9a6618ba3ffb6da99dbdad395246"
    sha256 cellar: :any,                 arm64_sequoia: "2055a1f5d7dc9a5ecd25b93590a260e7e5df8674e7fec31386228c08b2185b52"
    sha256 cellar: :any,                 arm64_sonoma:  "25f5361ff527f5bc51b820e05f4ab7f5c0175f7893d0f329bfdd8eac36f22743"
    sha256 cellar: :any,                 sonoma:        "ae48ab1112efae4300ebcd229343950c9ef79cc06c6587c7cc6e3af9ff901251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebf3a6ce083b915f110c2b7e9c7f09c3b6da6c8e4d58e92c8054e175209cfb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aead1780b8c4440fe2a31f4a95428a47fc12bfd298f740bd6d19cf586f6dbdd2"
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
