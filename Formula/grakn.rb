class Grakn < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/2.0.0/grakn-core-all-mac-2.0.0.zip"
  sha256 "b3dc73f3a22d94f8f8d546c6b96e186db3fc9369bde306343098fed777c8fa7f"
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
