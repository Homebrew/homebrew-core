class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "7cc0adf315e5b91bd5a148725ef7c61c9271077b715d19ec62b416de35a82adf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc52eeeef3cfcdcc39f8bdd9ecda94856590dccb014f8e4d9bcc294d3c5f5bcf"
    sha256 cellar: :any, arm64_sequoia: "f4a921a46436130fdbc48cbd9bc45703bafd19cf79680215da16408175f0cbdb"
    sha256 cellar: :any, arm64_sonoma:  "75dd2bf6bd06570575d8dcf1f7c3b767458f5766635ef5f391ba8662813ae469"
    sha256 cellar: :any, sonoma:        "d87acc34143274c1a1e9d3bcef0d80e94c1a4fd5cfdd20f0393ae382f058f269"
    sha256 cellar: :any, arm64_linux:   "971b3eeb12ff96bac1c15416d5fc8b4b37df1931611626d16e957b48d220db0f"
    sha256 cellar: :any, x86_64_linux:  "36b470eecce3987ac340fd8a8507a0be20b30257318a675d44fd339c00559743"
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
