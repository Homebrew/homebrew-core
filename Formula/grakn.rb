class Grakn < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/1.8.3/grakn-core-all-mac-1.8.3.zip"
  sha256 "e8d2a96c4b6144113ebd71781041168fe8dae2b115602b25aebe16960931434b"
  license "AGPL-3.0-or-later"

  bottle :unneeded

  depends_on java: "1.8"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"grakn"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match /RUNNING/i, shell_output("#{bin}/grakn server status")
  end
end
