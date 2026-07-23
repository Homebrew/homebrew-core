class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "7da5abe698227bb1b0accaa9a9586586966dc9faefda179daa36ebb25163caaa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "853963bb356e7cc644eb6b7b28edd070660f5adfa9ac9859d68cc87ab408e050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58312d2db0ec20dd2d3de2204b52e0ca39b4f1605cbd2e4157337dd290aab185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb540fafc406f370da3572bb944f032919e225d382c7bd261d14254e9e3cfc8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf6c7f23c1aff2b366bb5de7c7d7d429a2646e1bad1780625db0540dccea391b"
    sha256 cellar: :any,                 arm64_linux:   "c3994ffb35e39585336a52d7c6a97fa13e93d4817744e0d2739de8df2e81a36f"
    sha256 cellar: :any,                 x86_64_linux:  "d013a93643d6434864a23a84372f544d64bdb0b1179c8ba78e8b1c4c948b4a0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"test.md").write "# Hello World"
    PTY.spawn(bin/"mdt", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "Hello World", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
