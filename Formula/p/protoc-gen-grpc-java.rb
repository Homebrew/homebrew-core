class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "ce1afcdf5130e74138e93a0f9f0bb77241610d7f00c987f46dffc5fb083f6f0a"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31ff91c682fb0b58c75cc521ef2fc4f35bf7f753f822c9b40dcd087edff1e881"
    sha256 cellar: :any,                 arm64_sequoia: "e0e5ce91ffd05519f011a9bbdb5886c4e0d85d57e5f3508c3497d11d3cb1836c"
    sha256 cellar: :any,                 arm64_sonoma:  "16ef57a192b72ba92702c7a38e0209f0242bd10a0825e37f9a519ccf4b8fe5a9"
    sha256 cellar: :any,                 sonoma:        "03d033c130bb0ef1cfde67849fdce6325afcc87f5beeeeb6cdcf04d76ce605db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1793129cef9d78b34058982fdad5a1679d3462428746f09c26e6744bbbcc73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e4b847ecc8d3547354da88a2154330625de473213ba8fff2da467fc75e6d552"
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
