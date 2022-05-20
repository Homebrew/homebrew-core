class OpenAdventure < Formula
  include Language::Python::Virtualenv
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e931395590510f74d6bf59fa5c23c3dc1ec8c8fff3a7d155ff28b4e613e2f71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0d181283936bbf39d920d378514d7d458ef93a2467b6bd6a8f31670540fe98f"
    sha256 cellar: :any_skip_relocation, monterey:       "2babb876201536cbcbd9a40a25f5ec0af425ff4fe6e5726f90252d56baded949"
    sha256 cellar: :any_skip_relocation, big_sur:        "4574d326ac02f5ecc8623577de5c6d563aab95c6c38daff5e3ce3044a7730f63"
    sha256 cellar: :any_skip_relocation, catalina:       "9879361d26e9dbde8294dead6e8b98f795c0a09950a5a6e92a9a7b057a5dc38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d275c1e16d3d76e8e57875dfae24e28618001f72c88f6f2b067b221badb5ed"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources
    system libexec/"bin/python", "./make_dungeon.py"
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
