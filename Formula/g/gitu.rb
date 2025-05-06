class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "a6eafe8fc5ce0dfec029d919bc970de330e6d5d8404d7f57ba89be27e7feec1c"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ded9c5875c835df107d664a0c19397e6ac8ef989035b456eded97d619ff4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541aefb18ba19fa9efe9a9450b9a028b5c6fe600aa6c38615e9a5bb3d17fdb3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "deae137c427764d86c006ed8247af8b6f6ef73d3c2864e5e073263566174b18e"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c10ba1b0f94e63cc945e3d2d6f40268a16d4e6f3c3260a7ad1672bb6e7dfae"
    sha256 cellar: :any_skip_relocation, ventura:       "e3ef2fb47522664afc8c238fcb5d032d17e97f76b2ad3dbffcf1078382d5368d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8796fec41b1d3027f346bf3296e0c11dd74ba76270641359cf0fb2b9820764c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0b1adaa66d8e1f33afa763077ea0484ff981ee12b1b937c45b8e22c05a9b58"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository", output
    end
  end
end
