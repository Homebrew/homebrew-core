class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "4ac03e3244da9565f13f62a24e87f57ee13baa7657033db35ea086e16fc32869"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c78946f57be9177d00d9662b29445ba0f5bd336016023007f930a675de9f2b40"
    sha256 cellar: :any, arm64_sequoia: "79c643fd1ada27f9a9ab963594c2efe079c8402d110e610b7a5649fcb7e8ac3e"
    sha256 cellar: :any, arm64_sonoma:  "d1f9b4acf35b5bfdb013fb94209c4bf2cbd2bac856592f9e27e857dc98a66e9e"
    sha256 cellar: :any, arm64_linux:   "21028e5f939de70b369d7f74b43af955e0942a1b1ddb0ffc629922d3b5e977ee"
    sha256 cellar: :any, x86_64_linux:  "d13733a10af0165e2880252ac9883a62791288d82ec2bc753ed6141d8b618194"
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
