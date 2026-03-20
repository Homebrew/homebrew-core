class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "d202e1759913b3d789052e5d243a994a44d1a30b6fc0f4286802c859ffd8d866"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4c4be648d33291f0ba97e419735a0c4d6881bf174e287fc86787ef84fb75dbf"
    sha256 cellar: :any,                 arm64_sequoia: "545999e2d46e0f88143189b1ae42e8d9034c829b25d9e2226c0437d435f993b6"
    sha256 cellar: :any,                 arm64_sonoma:  "0bb5b1f62aae911f10a38b32f1a55fb969dee917a72c5891aff9abb65ab586cd"
    sha256 cellar: :any,                 sonoma:        "8342670df17a956b758488bc525684ed985fdebbaed366b91a8ed082650e8b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62a00f7c0749e0bc331c508e5e6ab3f9ed9003a64e73e1f06a2626565275fde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022e3ba2616e427ed638cf97ec9dafb6faa575174e42aa9921f2744f4dfde2ff"
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
