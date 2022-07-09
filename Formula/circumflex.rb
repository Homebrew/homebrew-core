class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.2.tar.gz"
  sha256 "6a2467bf6bad00fb3fe3a7b9bdb4e6ea6d8a721b1c9905e6161324cfb3f34c01"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
  end
end
