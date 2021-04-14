class Grakn < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/2.0.2/grakn-core-all-mac-2.0.2.zip"
  sha256 "7606ad6951d91b2942ea0e2d3349d636e0b1b54c72e1c888be2616aa99fc70d0"
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
