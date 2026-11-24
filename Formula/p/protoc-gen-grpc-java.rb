class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "6bf087bf5bb0dd616d66e8af34b400478d7e770688e0476fee2210d8fda4dc23"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "0b33fdbfe502bdc658619ec5fabd5904e56fdd4abb0616bf3c2ee1578900478b"
    sha256 cellar: :any, arm64_golden_gate: "85088abe4a5369888825bd8290af1f52b7d57f036a9bf06a6d830754d1aad8a0"
    sha256 cellar: :any, arm64_tahoe:       "b048b2641927b8bd5834c1fd5b5864682b2db0f41e9d09e2f68fbb2f1220cc4b"
    sha256 cellar: :any, arm64_sequoia:     "061e87f1506ea9a1cfd003edd3fadc093418d6391760d0efb7fe840eae73aaae"
    sha256 cellar: :any, arm64_linux:       "136827bdedeab6589705d640dde817af20c26a2ff10f4db641dd646348d0bc27"
    sha256 cellar: :any, x86_64_linux:      "cc4b29feb7c81acf4a46750537295b643c4d0ee9f6d9791ebd69232b0ba37c6a"
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
