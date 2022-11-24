class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.11.tar.gz"
  sha256 "150880fd47a4b8c98dc7748e62bf3e98839f5384b497057aa91c84e5935dd340"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e12500870339890aa4e38adb46743e8cd2459645749f98b985c126a039c26a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e626a51cb92c97db9628a4dd4f3220b4aaa5fca24b044e9d84b1a27986597e47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b775593afe027000123bb388f84553f5c2213a566cce24eff46be74e96f000c9"
    sha256 cellar: :any_skip_relocation, ventura:        "45c2c8b7f32981e7c6be6b4be03c6f076c8fedb0c754f985cac236ceeefa5a04"
    sha256 cellar: :any_skip_relocation, monterey:       "207d746678eb8bc2d241af54fcd33785cc25066037d4211669321304a6d9dfab"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf645264db48637a2a60113fd80945feb3048e1b17d6e77bf1c6970bb6f621ba"
    sha256 cellar: :any_skip_relocation, catalina:       "c49210129ed491e094473e663171f5f6a554b41c3ba319cafc4fdc7d25289c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12d65ac8f76be7b2393bff7eb8672582b840732e3228351e5d8e2fb5b13dafb"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.10" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.10"].opt_bin/"python3.10"
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
