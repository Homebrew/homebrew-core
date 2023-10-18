class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://www.guardsquare.com/en/products/proguard"
  url "https://github.com/Guardsquare/proguard/releases/download/v7.4/proguard-7.4.0.tar.gz"
  sha256 "5b5f1ad8d83e20c123df06d8cb10863c3570d8aabb6aec954f5fa1dbf8b5298a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9f46b6bdc244a06566cbdc3689ea8fb9e778a6e9411d6cb0e3c23438af93c2c"
  end

  depends_on "openjdk"

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
    assert_equal expect, shell_output("#{bin}/proguard", 1)

    expect = <<~EOS
      Picked up _JAVA_OPTIONS: #{ENV["_JAVA_OPTIONS"]}
      Usage: java proguard.retrace.ReTrace [-regex <regex>] [-allclassnames] [-verbose] <mapping_file> [<stacktrace_file>]
    EOS
    assert_match expect, pipe_output("#{bin}/retrace 2>&1")
  end
end
