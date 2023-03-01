class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.13.tar.gz"
  sha256 "cd5e1e9682cf75c12ea915ed3e8a3eb26fcaceef8f1cfbf59011a0e4bb5fcc88"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8938593859998a112c053d0e323545cf7827919ff2f0fead50f137994ece929c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d3583727927282f48385c9f9546024db0bdc680e7e30704214023533fe1fd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "123ea99c32d8aa671ba7dfbf923181b4e43561179f4d9d9a0d6a39c907c06065"
    sha256 cellar: :any_skip_relocation, ventura:        "5624298331d6dbd57f857f1c47284ea7516af65dd09194088095b95ad9b84c20"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e0078dbf3740ab22f3217e3ccc7955a87fa9c770ff8ead1fba8e2246855af8"
    sha256 cellar: :any_skip_relocation, big_sur:        "65f339d5f226a7d797ef08a1f0dc87128fe140d22a6486d260acc320e93671ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671bacafec5d29e464486e7ae038c7bda0e6a7af15574f4a37d04cb4122d91e0"
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
