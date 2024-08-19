class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v6.2.4000.tar.gz"
  sha256 "c5e04bf1a43c6a3c326e302f8739df1440a5cee164f47ec8b1b549a8c5e5cfb4"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d220eeefcc70016a436d826a89fe6311f9b9df7c1eedce4803dc152b6a4b423"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a863eb03b5f3ec4f3184717314a626a060846ecf01d0f7f569a84286b1536f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e3feac19c44d8f730102a592e2aa5458805e59876c9d5029d0b97611c5eab35"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a0639c95e75b8e643e9bcd1e493657d3393b190edde6745a7a893f825f2fa73"
    sha256 cellar: :any_skip_relocation, ventura:        "f82c9c8cc596d7184263186b6a275315cba463eaf81b9d05cd0de7713da5d9c3"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb59bfec60bc31699881f2caefad3b0b224ad30b3f061508d6140bfab57236c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6dbf6d3c17017adbfbca80608992b16d3087c695f6c74fb31f321d761ec7fb7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
