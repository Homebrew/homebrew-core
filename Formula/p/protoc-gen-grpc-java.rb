class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.84.3.tar.gz"
  sha256 "69282196fdae3fae590829c792a55063cc18a38dd2bd28f841598aeff79af05b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "434bc5e0f6a3dc03e8d39d6177d60dab98b23c78546b41e6926bf9ed92b878bf"
    sha256 cellar: :any, arm64_tahoe:       "4434e0183b349282dde025585e360f6642fdf9441325f82690ec6a460f982184"
    sha256 cellar: :any, arm64_sequoia:     "ece9d22fd8a9b0bf78d049f89c904e4520ba2c1fb021bcbb564101227abaa91b"
    sha256 cellar: :any, arm64_linux:       "2c09bed579210c5e615b130dc16f38933edadba4e7435bf98c77c16d03ac1777"
    sha256 cellar: :any, x86_64_linux:      "a57ee4c0a38f696354105486ed39797dcecba8a12ef786f0cef71ee266ff45e2"
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
