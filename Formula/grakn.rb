class Grakn < Formula
  desc "The distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/1.5.9/grakn-core-all-mac-1.5.9.zip"
  sha256 "9934cf19b206e88193173d05d58e5a5460eebc2933a83a99bc807122db93b7dc"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"grakn"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match /RUNNING/i, shell_output("#{bin}/grakn server status")
  end
end
