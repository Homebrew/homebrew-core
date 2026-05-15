class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "8ba174657d86acae7978b0f4eea14a73e74b1d25ba4dee65315fab4ec9f2c041"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "638426ffda4e175e08102d82e30453297aad616010d2e0659d511747d65b0df2"
    sha256 cellar: :any,                 arm64_sequoia: "434b01d7d5dd45df30875a7d6e8cd6685b4ffca64cb18a63e01c0a7db9df86f0"
    sha256 cellar: :any,                 arm64_sonoma:  "f32c764aebef425ce1a57bb07ffbf5ccdacb646dca419edb95d4cdb3a7b11c0c"
    sha256 cellar: :any,                 sonoma:        "755d2b42460eb184100250f3132782b9dab1349103ba3a9e989019c8b4b7f2e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b04ab6fe7f31c32e33786e0f84414200f264119dfd8153805a3d330ceb1ddca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3f1caf8133c6b7f602b35dc21f5b51ed6ea4728e4d29a3f2c66a5729c18cf0"
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
