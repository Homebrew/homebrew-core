class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "eca44a9f3eb341daf7a01482b96016dfa7d91baee495a697746c4724868a06db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7dceeffe15dc656a5435fbe90d14a4bcf88f2c862b5e275542535b0bff9e9545"
    sha256 cellar: :any,                 arm64_sonoma:  "a8e2aab74094c8c4efc19b814fd01c10590437a13aba81f78321eafe14fac241"
    sha256 cellar: :any,                 arm64_ventura: "3f39c01a0b50a8e91d03c8a12a30f94b5c58076bce2a56354eeeae01d7330c8d"
    sha256 cellar: :any,                 sonoma:        "1a076b7c28ceb75364310043c0719d079212f3c8605996fee85944655719517d"
    sha256 cellar: :any,                 ventura:       "a1db559ddae8aee30e6ab66eb68efd8ecd44baa9e046f0aca336d77cb73a3f29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a801355ffe855146dd366358f6426fece82e485dba2c6d9c91d06ba69598318a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2dacaa34a5f811c69a9b768a21f7234b3163698127afd78793870ffbd8b20ce"
  end

  depends_on "gradle" => :build
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
