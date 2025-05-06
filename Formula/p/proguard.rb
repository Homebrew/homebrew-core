class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://www.guardsquare.com/en/products/proguard"
  url "https://github.com/Guardsquare/proguard/releases/download/v7.7/proguard-7.7.0.tar.gz"
  sha256 "6769a5c6219a81651c34554228497b52a4fc162d341e2ff07875b32e730c64d7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6cbbd228033de155297ce16984c8f4b876c85c9d4d398c72060241bb5a01e735"
  end

  depends_on "openjdk"

  conflicts_with cask: "android-commandlinetools", because: "both install `retrace` binaries"

  def install
    libexec.install "lib/proguard.jar"
    libexec.install "lib/proguardgui.jar"
    libexec.install "lib/retrace.jar"
    bin.write_jar_script libexec/"proguard.jar", "proguard"
    bin.write_jar_script libexec/"proguardgui.jar", "proguardgui"
    bin.write_jar_script libexec/"retrace.jar", "retrace"
  end

  test do
    expect = <<~EOS
      ProGuard, version #{version}
      Usage: java proguard.ProGuard [options ...]
    EOS
    assert_equal expect, shell_output(bin/"proguard", 1)

    expect = <<~EOS
      Picked up _JAVA_OPTIONS: #{ENV["_JAVA_OPTIONS"]}
      Usage: java proguard.retrace.ReTrace [-regex <regex>] [-allclassnames] [-verbose] <mapping_file> [<stacktrace_file>]
    EOS
    assert_match expect, pipe_output("#{bin}/retrace 2>&1")
  end
end
