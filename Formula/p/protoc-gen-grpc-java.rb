class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "4ac03e3244da9565f13f62a24e87f57ee13baa7657033db35ea086e16fc32869"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "313d429d7f1db7871d63277c54ad06522408220d43b72a06881cc1ffc4ff8352"
    sha256 cellar: :any, arm64_tahoe:       "17733991e1ab664ad5cb6b9848828c7ccb1e652ffe84880df86b1b5557a0593c"
    sha256 cellar: :any, arm64_sequoia:     "2385c35f9cc006ef1a443028daed6881a27d93d32ab76cd423af82d88cc969c9"
    sha256 cellar: :any, arm64_linux:       "6b1057a6204f4b51436006fb29ac811a52aa0181db54d0851f887e13b8e75c17"
    sha256 cellar: :any, x86_64_linux:      "ccb2bf62bc88dcea4e960a1f9afd392f4479fd66730e8e0909e1949c2c9e6abc"
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
    system formula_opt_bin("protobuf")/"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath/"io/grpc/examples/helloworld/GreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end
