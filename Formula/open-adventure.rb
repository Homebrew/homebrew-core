class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.14.tar.gz"
  sha256 "6682b8c45788615d7ed38efe9b24eb8f47c1754047cff8591756ac49c90d7f8f"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d24866563a97c827a30cd7276d0b1b50e0ecdb1b451051da2ab942b03f5cb52a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0ae14af270aff0879c3286e0213e67dee1b46608a0f2b2243db942e98130d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8900df2507d0b7d9e223545d81a32a4dec12ae37f66335b9936f826e48e150c3"
    sha256 cellar: :any_skip_relocation, ventura:        "ddc7e79e29b06b233c016c463a2da5e4457c2132e33961e64dfa883b6da71f40"
    sha256 cellar: :any_skip_relocation, monterey:       "7c6856dab0a9d2b00b5592fb37dc3e93225f257f4ea59b8bc4ec62bda9b78742"
    sha256 cellar: :any_skip_relocation, big_sur:        "7986662fd23757197f6d1b079ea124e010e0c9925e56e1768325e08609062920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d078aa878ae805929303ada0f7c320a1d59ba4b35a0ab2217ddc62020ead35"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.11" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
