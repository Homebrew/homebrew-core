class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "29e7d527ccadbfb8e0d22b15569ba566a33706bc63345f96c44a6717f6ac634c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9b7c56f97955b163e55095b867c81f8f81462dca759049051bf2c63d4bee494"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a2ad00e8917da2c279692adee97a01c382b1b74ae2164f3d119a01a611a6ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cda9a80fff85ee1a0fad36b3f5f8fcfa04b90f9cf633dce6b146532d297ddbbe"
    sha256 cellar: :any,                 arm64_linux:       "9d79b202bcaed582546166891c9896a9181a4f9d03e59ae1fca1888c343d448a"
    sha256 cellar: :any,                 x86_64_linux:      "609e6a045a3c4bfc6d8fbe748848ccb4f92dbbf41c5648f635230ba3746122b8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
