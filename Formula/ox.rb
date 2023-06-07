class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/0.2.5.tar.gz"
  sha256 "873eb447029508bc3fd1d7dda8803d79a7b107a7a903399947f4eac6ae671176"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b6f240abd8604307a727c97b0d42a5e5a3f700ad43230fcf8d954cccbcb88b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf48fc9e0d95c4cb8ad6dac58503650a40b05d719a990d3cf5b8e6b25f81bf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "606fce16c59db5ca5c28ee0c8162358c6cf49003ddd34a9f5c7e79becf085fc4"
    sha256 cellar: :any_skip_relocation, ventura:        "de539b24b4d2aba9733601f62a07fa1958fbc01ce84b9efb2aee5dd66c31bf4d"
    sha256 cellar: :any_skip_relocation, monterey:       "c3cd24406c0cf8ccd53df8e4d5e42faf2ea5adcdcee01c10de3e42c58c74f162"
    sha256 cellar: :any_skip_relocation, big_sur:        "deebe47c0268ed7bfcea1a0647d8e7efeb0144ed582336aaa37863ab07c4273a"
    sha256 cellar: :any_skip_relocation, catalina:       "03e1fb3e45d2142be9f240fc453cef636a16e9b56171c37a48e9a3a0fda5f487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aff8a390b565c0c3d7057b512371081c3c626332f29c3ced27507f395b335531"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    _, w, pid = PTY.spawn(bin/"ox", "test.txt")
    sleep 1
    w.write "Hello Homebrew!\n"
    w.write "\cS"
    sleep 1
    w.write "\cQ"

    assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
  ensure
    Process.kill("TERM", pid)
  end
end
