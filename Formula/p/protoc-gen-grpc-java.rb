class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://github.com/grpc/grpc-java/archive/refs/tags/v1.69.1.tar.gz"
  sha256 "970ac87fccbaa6c978dc56b0ba72db53b6401821c01197e1942aecb347e5f218"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c3eaaab27793585e4b386df7f62160b11176d9b7ece602b95a8c332cfd10cdc"
    sha256 cellar: :any,                 arm64_sonoma:  "699e5a89b3b9dc27df82b875416f0171a6d3ad3968b9ceffd26e655e7f5b2797"
    sha256 cellar: :any,                 arm64_ventura: "8ff0e0c07acd32f0abdab6ce19b4aab561df0a68cd254b77d951674afc775f5d"
    sha256 cellar: :any,                 sonoma:        "8113624d7f44edca9b1ff210c285f7225bdda3c8b56b320b9ef09d659dd24ca0"
    sha256 cellar: :any,                 ventura:       "3839e6dcaee5f5173cfa6d3c3fc0ddf64b3573d8d97935fd34d6775c9cea6cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6038f32c1b7707a2852363fc25b3b79457bcfbaff10c17a4469c066ff394e1"
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
