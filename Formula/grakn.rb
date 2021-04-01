class Grakn < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/2.0.0/grakn-core-all-mac-2.0.0.zip"
  sha256 "f4c03d8c19f908cb707d483987301b551c035ef0a2cb4b1ee1a56de4d946aacf"
  license "AGPL-3.0-or-later"

  bottle :unneeded

  depends_on "openjdk@8"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"grakn"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match "RUNNING", shell_output("#{bin}/grakn server status")
  end
end
