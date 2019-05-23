class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://proguard.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/proguard/proguard/6.1/proguard6.1.0.tar.gz"
  sha256 "0b71d441ac2df4d5186277c6050328903dd9b0062cb9d9f02937d1a00b55ea18"

  bottle :unneeded

  def install
    libexec.install "lib/proguard.jar"
    libexec.install "lib/proguardgui.jar"
    bin.write_jar_script libexec/"proguard.jar", "proguard"
    bin.write_jar_script libexec/"proguardgui.jar", "proguardgui"
  end

  test do
    expect = <<~EOS
      ProGuard, version #{version}
      Usage: java proguard.ProGuard [options ...]
    EOS
    assert_equal expect, shell_output("#{bin}/proguard", 1)
  end
end
