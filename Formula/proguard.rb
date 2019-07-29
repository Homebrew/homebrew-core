class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://proguard.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/proguard/proguard/6.1/proguard6.1.1.tar.gz"
  sha256 "f76444c49d1d4f8e9a635ed812a33c4ea586bef308479dacc19ee55ae0289186"

  bottle :unneeded

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
      Usage: java proguard.retrace.ReTrace [-regex <regex>] [-verbose] <mapping_file> [<stacktrace_file>]
    EOS
    assert_equal expect, pipe_output("#{bin}/retrace 2>&1")
  end
end
