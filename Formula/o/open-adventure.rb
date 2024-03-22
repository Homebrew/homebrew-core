class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.18.tar.gz"
  sha256 "9c2b71b8b44c96ac30cfc3ebacda5e35dab724ec2d63e91e3aebcaf25f852c05"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a63d7f1a240537727d295907a4923a7ebbf0d68c4d47b1a7d3d3b9ec4b9fd95d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e024181cba453672dc901576ae313f53760bbaf2b2a236e0c611fc47f008bac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87e0434ae6409afd4dc0f11cd493621e74789efc9bb3b463ac6b3c2ea0d379f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b229a6abf4e09c078d9a79ba6912da1c4b2113f0aa93bd99649cfdc99012e17"
    sha256 cellar: :any_skip_relocation, ventura:        "2839076eede9bd947187276a3c9885d9080d666f8ecb6a2291377d93533db0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a999beb6a0499ae9ef64f093ef47a3ea1e712542260a4aee54b414f471daaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590ea3f268a787c2eb7d021693e3260f044959bd96767a64d63d787d19a7a8cb"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.12" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
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
