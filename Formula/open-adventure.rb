class OpenAdventure < Formula
  include Language::Python::Virtualenv
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.9.tar.gz"
  sha256 "36466882af195d402b62deaa08e4cef26d1646cf1329f14503ea06fdc5c7219e"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b220fb93f56b0e6007f9b25d31d9d64d86e6976a6cbc479c0abd115bcd468d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e6e5fe49a6e152e07666b01ef6ce83063f1de437e65970079656e8ae4c2e357"
    sha256 cellar: :any_skip_relocation, monterey:       "da5283e16c1fb5a6ed671bd8490e43065325268d30289872851c43c477514c89"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ec563817f679d2ed97360b1d32e3fef297eaa3fcaf582044213532a338d217"
    sha256 cellar: :any_skip_relocation, catalina:       "19315161a1ca025476f7bff681bbed32d52e0c462ad8de013ae2442f5cf37d08"
    sha256 cellar: :any_skip_relocation, mojave:         "950ef945af942573058ad712f85547fff68d282caa403ae8645ccf4a90ae3d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "477e0809fe0844f0075943170f4554b716638a2b9f43b2c41531d48311edcf20"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.9" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    venv = virtualenv_create(libexec, "python3.9")
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
