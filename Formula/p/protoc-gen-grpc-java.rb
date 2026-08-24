class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.83.1.tar.gz"
  sha256 "0a110b4565bae8fddc646bb731e733331819d2cf89017764aa68b15495297b81"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "152be3e928f63002bcb1ae9ba835d5208b9f296cbdcd81795b3386a242c45f27"
    sha256 cellar: :any, arm64_sequoia: "fff95f3e6bc6cc0b4f2a78f7d7a3df270c7a9321bc98ebccbf9edf6b23c18c0d"
    sha256 cellar: :any, arm64_sonoma:  "299b30a7e5d0420561462fb39e2e6e45b51c469d47df5eefc5cc07d5aecff186"
    sha256 cellar: :any, sonoma:        "cb42389248981d04c31ffb0fc3731987a2797f339d71e9ab4744b568aef5de1c"
    sha256 cellar: :any, arm64_linux:   "258894c50fa7e9aa7115597463a562319d7f188f178d2c65d10a7f25341cb711"
    sha256 cellar: :any, x86_64_linux:  "a01f7af5e811801b054764e676c037c6081dd491b4960a87ba4b9c235690f63e"
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
