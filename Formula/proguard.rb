class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://proguard.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/proguard/proguard/5.3/proguard5.3.3.tar.gz"
  sha256 "95bf9580107f00d0e26f01026dcfe9e7a772e5449488b03ba832836c3760b3af"

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
