class Lsoff < Formula
  desc "List listening TCP and UDP ports"
  homepage "https://github.com/yutat23/lsoff"
  url "https://github.com/yutat23/lsoff/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "25117f42705801040ea63bf09cf6396a063d54c0087a7ce6a57554195b5f17ae"
  license "MIT"
  head "https://github.com/yutat23/lsoff.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsoff --version")

    output = shell_output("#{bin}/lsoff --kill 2>&1", 2)
    assert_match "-k requires a port", output
  end
end
