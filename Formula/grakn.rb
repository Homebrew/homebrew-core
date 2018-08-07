class Grakn < Formula
  desc "The distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v1.3.0/grakn-dist-1.3.0.tar.gz"
  sha256 "4ba57a0642c4dfc83d43053133d01b08f0c7c31ba98a56ae46cb9d52016a71c1"

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
