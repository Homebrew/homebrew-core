class Grakn < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/1.8.4/grakn-core-all-mac-1.8.4.zip"
  sha256 "136b6933a643959d31d1f9c964bcb161db52a01c7f51ff7fa156335c0004ce54"
  license "AGPL-3.0-or-later"
  revision 1

  bottle :unneeded

  depends_on "openjdk@8"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"grakn"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match /RUNNING/i, shell_output("#{bin}/grakn server status")
  end
end
