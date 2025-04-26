class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "946d734843c9e69bac29aeba65c4a900b106606beb6c4bbbd31c65971cb214de"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3652e7a2c5644ae79c9655b1357028c4d05dc9b02b185d026cd67dd93c0f792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4756ece8bd6528cc312673ab148af7d413cc7806d00f27caeb5df19608e6fb77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8280ffc7e945988f50379b8b53616353264c6892e974f2b1f65d622c6b8431c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "94fd623ae26355a1fa4f5ec446ddc4da4fe64c362c6b804331b1fd7bd0c49e4e"
    sha256 cellar: :any_skip_relocation, ventura:       "ce92acce286188797e70e2f3c1a3a980b2c4bb367027bfef7f56d87c5a333c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698d700685f0141a0cbb88423f394aa76b79def9af4ea270d9da0112cce2b634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6873ec87febfefe0821660ae55267e8bcaa31e771cb31d0b9b5d794e64cbcdf4"
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
