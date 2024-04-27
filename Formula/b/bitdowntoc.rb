class Bitdowntoc < Formula
  desc "Markdown Table Of Content (TOC) generator"
  homepage "https://derlin.github.io/bitdowntoc"
  url "https://github.com/derlin/bitdowntoc/releases/download/v2.0.1/bitdowntoc-jvm-2.0.1.jar"
  sha256 "17969692be48f9320fbc075167a6a28853e6cc50adb11db011b15cfefe277f85"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    libexec.install "bitdowntoc-jvm-#{version}.jar"
    bin.write_jar_script libexec/"bitdowntoc-jvm-#{version}.jar", "bitdowntoc"
  end

  test do
    assert_match "BitDownToc Version: #{version}", shell_output("#{bin}/bitdowntoc --version")
  end
end
