class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.2.tar.gz"
  sha256 "b48cde13d031b7f5a4b3b6e656307fea100c0c57202f714ac612295e1d40f45e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77b1038ca4fcf0a771f311c92793e113fa4a9509902e87a0b28ffa5528e7310a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b1038ca4fcf0a771f311c92793e113fa4a9509902e87a0b28ffa5528e7310a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77b1038ca4fcf0a771f311c92793e113fa4a9509902e87a0b28ffa5528e7310a"
    sha256 cellar: :any_skip_relocation, ventura:        "bfbe94d8038a18898d8a28f34207d1170df8cb7f71e79928d612176250753159"
    sha256 cellar: :any_skip_relocation, monterey:       "bfbe94d8038a18898d8a28f34207d1170df8cb7f71e79928d612176250753159"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfbe94d8038a18898d8a28f34207d1170df8cb7f71e79928d612176250753159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68758702ed0726b8cba9a9fa643915cff7e5e34f28a1cb60f95851b8dd8ea5ee"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
