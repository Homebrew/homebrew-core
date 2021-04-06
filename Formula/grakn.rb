class Grakn < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/2.0.1/grakn-core-all-mac-2.0.1.zip"
  sha256 "aed1184cfc143d3ee08fb55b2559d1ef35dcef2de7237ae9acc24e7faa34dfba"
  license "AGPL-3.0-or-later"

  bottle :unneeded

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"grakn"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "THE KNOWLEDGE GRAPH", shell_output("#{bin}/grakn server status")
  end
end
