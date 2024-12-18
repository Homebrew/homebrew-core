class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "5c3178f118190d73f52460d671c7b6fc42249b7b5890d228ce422f2ca20b1a68"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef1e127bb0cab38818e5e219aa737e3c5909a0e514d73a595e155a32938a88f7"
    sha256 cellar: :any,                 arm64_sonoma:  "5620259e32678f258f3c6ff0a9afcfe216ecb7855350890751ca752cb80884d0"
    sha256 cellar: :any,                 arm64_ventura: "e426ca677dfcad431ecbb75a73a9071b024a2f2a103618d1b7d2420acd15d898"
    sha256 cellar: :any,                 sonoma:        "f840ee048dbfa9489322dcdb58c899875c08f4f21f4c650c94e53fe9fb0bb62a"
    sha256 cellar: :any,                 ventura:       "f665395066fa079baacc95b4d03f489084ec95db177a20183c897b7d428a0fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d89838f8109c217190a21a1273a557ffe34551f2f5ab2bee7ebd9026c546392"
  end

  depends_on "openjdk@21" => :build # due to Gradle 8.5
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

    # Fails with brew `gradle` due to animalsniffer 1.7.1
    # Ref: https://github.com/xvik/gradle-animalsniffer-plugin/issues/100
    system "./gradlew", "--no-daemon", "--project-dir=compiler", "-PskipAndroid=true", "java_pluginExecutable"
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
