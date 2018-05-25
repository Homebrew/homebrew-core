class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https://proguard.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/proguard/proguard/6.0/proguard6.0.3.tar.gz"
  sha256 "db175575313d11eb75a3ab68c079123d2787529b63c5cb434b1f653ececb3e48"

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
