class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://proguard.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/proguard/proguard/6.0/proguard6.0.tar.gz"
  sha256 "fcbcff3c9ff8bb661f94d47c6612d9ff88e9db4f6ed47f817cac65e34bbcd170"

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
