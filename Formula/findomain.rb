class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/3.0.1.tar.gz"
  sha256 "7bbedd088a64557876ccd7e7da92f1f8a5b67cfed1aaf335cd5d2b2a5f1824ad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55ccd6d8f9da545c9832e440af212ad0544bd2df20b58fcd7519780d9fc88b93"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb204b4cd242fca47870a7ea606b2d895c7ca31bb379a7ca2430543983140e99"
    sha256 cellar: :any_skip_relocation, catalina:      "287516da14dc786c922aa2de166ddcddf8c031cb3057c758e80fb983354cd3e1"
    sha256 cellar: :any_skip_relocation, mojave:        "64753c162781bc596926ffffbc370c0e0632694e6fbd4c5abcb0c35c3f5ebef9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
