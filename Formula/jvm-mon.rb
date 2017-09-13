class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://github.com/ajermakovics/jvm-mon"
  url "https://github.com/ajermakovics/jvm-mon/releases/download/0.3/jvm-mon-0.3.tar.gz"
  sha256 "9b5dd3d280cb52b6e2a9a491451da2ee41c65c770002adadb61b02aa6690c940"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/jvm-mon"
    system "unzip", "-j", libexec/"lib/j2v8_macosx_x86_64-4.6.0.jar", "libj2v8_macosx_x86_64.dylib", "-d", libexec
  end

  test do
    system "echo q | #{bin}/jvm-mon"
  end
end
