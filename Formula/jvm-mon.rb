class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://github.com/ajermakovics/jvm-mon"
  url "https://github.com/ajermakovics/jvm-mon/releases/download/0.3/jvm-mon-0.3.tar.gz"
  sha256 "9b5dd3d280cb52b6e2a9a491451da2ee41c65c770002adadb61b02aa6690c940"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, all: "27e30abfe7f273fa4e1194cc674c979b07694a44be43485c360a60bf533e183e"
  end

  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]

    (bin/"jvm-mon").write_env_script "#{libexec}/bin/jvm-mon",
      Language::Java.java_home_env("1.8")
    system "unzip", "-j", libexec/"lib/j2v8_macosx_x86_64-4.6.0.jar", "libj2v8_macosx_x86_64.dylib", "-d", libexec
  end

  test do
    system "echo q | #{bin}/jvm-mon"
  end
end
