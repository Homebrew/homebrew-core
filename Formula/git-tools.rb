class GitTools < Formula
  desc "Assorted git tools, including git-restore-mtime"
  homepage "https://github.com/MestreLion/git-tools"
  url "https://github.com/MestreLion/git-tools/archive/refs/tags/v2020.09.tar.gz"
  sha256 "55d792bc98150aecebd1e1d62ca9c2349ca28737ae60cd6c1e92185b32cc8c9a"
  license "GPL-3.0-or-later"
  head "https://github.com/MestreLion/git-tools.git", branch: "main"

  def install
    bin.install Dir.glob("git-*")
    man1.install Dir.glob("man1/*")
  end

  test do
    system "git", "init"
    shell_output("#{bin}/git-restore-mtime")
  end
end
