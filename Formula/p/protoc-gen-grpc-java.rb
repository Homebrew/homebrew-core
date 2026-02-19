class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "ca53210ee823a15d9b1ebe86a36b564d6834fd0c049e207469803180b7f8a20e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b8d9c7d94b2304deb66aa8985e75efae1a858fe603fa3436f9231a924796395"
    sha256 cellar: :any,                 arm64_sequoia: "2ec7d0331e1db4daefe3856ffae9ec19048607aa7b7ec9b62bef76fec48d7dec"
    sha256 cellar: :any,                 arm64_sonoma:  "7978cbf06f6bf3d13393c67f375ca95e5a549d98745c1b677913bbd7462e5253"
    sha256 cellar: :any,                 sonoma:        "eaaa37819c533065e99740dc493e9f3a6657d961070991418e6f7fac3dc3484b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa6c375a7cd40113dc9aad5880111def0dbb4ec992830152aef290e9da13162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eaa1d2b6cf10232ae4f1e5bad3580385d892daa0d136cde28849ed114416f94"
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
