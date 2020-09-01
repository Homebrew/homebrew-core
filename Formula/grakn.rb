class Grakn < Formula
  desc "The distributed hyper-relational database for knowledge engineering"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/1.8.2/grakn-core-all-mac-1.8.2.zip"
  sha256 "6e3c450e5d787f38b86697be48c99a4ce4489dd00fdb095b3a78286a7dc88fc2"
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
