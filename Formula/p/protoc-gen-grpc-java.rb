class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.85.1.tar.gz"
  sha256 "67436b0b6666cd928dc6b7f32c738fce63c2b1b98984dbf351049af5203a853c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "30b090f23e3cc419233f3cdd7074ecfd6a36bd4d521c2be5fb7a9d09b776a3a0"
    sha256 cellar: :any, arm64_tahoe:       "3205363e07817c06d69c6619ef40255333ad5056a613493db36b89bfee6889c5"
    sha256 cellar: :any, arm64_sequoia:     "cb03859fe89ab426a9fccc84572a00090d19dc35863a7766fbb22f79d92d6635"
    sha256 cellar: :any, arm64_linux:       "5d04113f1b254a463cceb862d4b1f9f17907f63140ae67f8d85609d481822c7f"
    sha256 cellar: :any, x86_64_linux:      "d161e6d0e104ea2761e7d9a954e2725af7120baaf8f1d80b7989b7b36d06e54f"
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
