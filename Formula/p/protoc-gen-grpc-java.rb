class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "82d76f952bf30b8d6abc94572ac171ae0a8391b1d49bb82d162e39b986c52284"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30d408b338073afb2b5b4226e4f9792e1ea10ea41c8f7b760d2b0e4e6f04c8ba"
    sha256 cellar: :any,                 arm64_sequoia: "0b99d86b7a7f123d02e2454ec5df9e4606784a26ebb0814ec94db1236093d5fb"
    sha256 cellar: :any,                 arm64_sonoma:  "c8c5486c214d2bec4dd317c7027010446e6c08fac55a1b8e6b8b88e73bbc4c71"
    sha256 cellar: :any,                 sonoma:        "6b8b56e42c4499744ccf9d5e479238b3450197364dcae46b0b9ca87a245359f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5e383fc283ae71eb71180a247ca807d0c33c7061ce6cda8548fddac1e9ab0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b588349986539cdd2a533cf851a923f856a545ae4c5978016f47e0b0bff171"
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
