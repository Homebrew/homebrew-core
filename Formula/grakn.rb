class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v0.17.1/grakn-dist-0.17.1.tar.gz"
  sha256 "a4d190d95515b01ce736056e2d738d67c14298465ba7fb92df5295612bb91475"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"grakn", libexec/"graql"
  end

  test do
    assert_match /RUNNING/i, shell_output("#{bin}/grakn server status")
  end
end
