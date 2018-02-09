class JavaDeobfuscator < Formula
  desc "Tool aimed to deobfuscate most available obfuscators for Java"
  homepage "https://github.com/java-deobfuscator/deobfuscator"
  url "https://ci.samczsun.com/job/java-deobfuscator/job/Deobfuscator/lastSuccessfulBuild/artifact/target/deobfuscator-1.0.0.jar"
  sha256 "27d3da75c5398d7eeb8e1790c0dcef99c47a506caece26ceef95646028f6db08"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "deobfuscator-#{version}.jar"
    bin.write_jar_script libexec/"deobfuscator-#{version}.jar", "java-deobfuscator"
  end

  test do
    system "false"
  end
end
