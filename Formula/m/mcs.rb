class Mcs < Formula
  desc "Reproducible AI infrastructure for Claude Code"
  homepage "https://github.com/bguidolim/mcs"
  url "https://github.com/bguidolim/mcs/archive/refs/tags/2026.3.17.tar.gz"
  sha256 "c9bb3ae4bf1a5e22f7875ff596541d7dd6338c626c26e7f3a326799fff6cc75d"
  license "MIT"

  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mcs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcs --version")
  end
end
