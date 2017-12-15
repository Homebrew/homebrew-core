class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v1.0.0/grakn-dist-1.0.0.tar.gz"
  sha256 "bd616a01fe050898b2687985fac5ce2c834402d33de871112f894a726692a916"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"grakn", libexec/"graql"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match /RUNNING/i, shell_output("#{bin}/grakn server status")
  end
end
