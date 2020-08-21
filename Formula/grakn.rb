class Grakn < Formula
  desc "The distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/1.8.1/grakn-core-all-mac-1.8.1.zip"
  sha256 "24d0f66d682250c00a400f8ace24162dc1b246078b28da355374667a68631264"
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
