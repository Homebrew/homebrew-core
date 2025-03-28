class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "2942a56b794479a0bc1c0e69039c9ae615f1cb39d0e3af12af35c0eb3bd73fdf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eddb7acbcc4edcc0785283131a80fb2b003917aab3cd72725f879b93241cabfe"
    sha256 cellar: :any,                 arm64_sonoma:  "74ffcffbc652761997d38433bcdfecfde9830bb57bb259a071761b5d3a07957f"
    sha256 cellar: :any,                 arm64_ventura: "6accc306df2fb0278da95c82baa1fdbdd02ebb67e862e41616303df1a689196f"
    sha256 cellar: :any,                 sonoma:        "fb1a984cd2fdaebf1eff1ac2da5c98631e2f4842dbb8ced281a9cb3984d7ac6a"
    sha256 cellar: :any,                 ventura:       "c8a7ee5b8572243073a298694651bce4a6a371ed92339641c03c127cd8252fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9e9f5bbb70e8d6a1c867ae1e9633425b41ca14db0e0842c51879f7947b3ceda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5409cf2417b4765cfed0343613f998845d3290c31028b514ee8125e18bce4be"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # Backport support for newer Gradle
  patch do
    url "https://github.com/grpc/grpc-java/commit/60f6ea7b8eec1692fc877ec82dd67d6bb888f706.patch?full_index=1"
    sha256 "75f1061860e3a01f1e9c57c05bbdf461cd5b9bc3301f94f2b3db683264dee63b"
  end

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

    system "gradle", "--no-daemon", "--project-dir=compiler", "-PskipAndroid=true", "java_pluginExecutable"
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
