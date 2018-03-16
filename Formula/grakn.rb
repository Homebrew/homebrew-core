class Grakn < Formula
  desc "The distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v1.1.0/grakn-dist-1.1.0.tar.gz"
  sha256 "6f741bfe04e1ee3b72fd0e107298aec609958ae51c6bfd1040f3aba8b05b4a94"

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
