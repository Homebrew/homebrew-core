class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "8ba174657d86acae7978b0f4eea14a73e74b1d25ba4dee65315fab4ec9f2c041"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f829ffe09000bf387f1ca5ea2c66dbd58b1afcb476072ce27f1e95b342eff5b1"
    sha256 cellar: :any,                 arm64_sequoia: "0d2266ccbd8c2c0d90bcfd4f200b24578cd0e928d3a762052a47c989f33d268c"
    sha256 cellar: :any,                 arm64_sonoma:  "0ab6e40db237d702bd59f15560cbafa9bca4361cfaf6f32a9d8a01c661f5d338"
    sha256 cellar: :any,                 sonoma:        "26a53a70895aa1da30c5d5913f7a93e30713615291102618dccc44ca97c22b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08c98b1511fdbb421d4c1f998b303bbdcfcc9e76583efc9b5bd76d4669276d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c71183256e602ed0e1e0111ccdf28ea7dc0ec796d7809b7d2e9716c366b43ce"
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
