class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "d202e1759913b3d789052e5d243a994a44d1a30b6fc0f4286802c859ffd8d866"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fdfd65795f26e2b4c3291d9a0becf9c9b2f7d0f5a607f5306dbd378d1863843"
    sha256 cellar: :any,                 arm64_sequoia: "0c01828a2a7fd57733383c7207dbd22946bc11b59ba75f9fa4245afba6727a77"
    sha256 cellar: :any,                 arm64_sonoma:  "41e45b321e9606a9116fd36bff474b3bed12bc7b4162f13a2435d4d0620333e3"
    sha256 cellar: :any,                 sonoma:        "8dbb188b4e89805e1c694c6ae9f8169952665614d8acae7204ea740190d34690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5cc820d64ec563c3421ae46e70e966314c1e20dc2be7e317b10a5acf95db718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6c2aa1cf00b724ee971c26b75073c2191f7bbb627dbb4f5a0eb8b41c1c699c"
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
