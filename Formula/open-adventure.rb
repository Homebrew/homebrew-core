class OpenAdventure < Formula
  include Language::Python::Virtualenv
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.10.tar.gz"
  sha256 "e0fc4c5d1aae0f27ace48af7cc45c9bde582a0eb305bdcb95e31b1310f32daa1"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86fcdbe8ebab9390044fde83cafe0888ae77ec312b995c0d65c779e505872a8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da6bb68cfa20c6129afd03a61a85c8f0cbe8d545b76caece7664b16b80cbe66b"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae49f7da1bb7ccb87a8e90a137d61ff957bc96f0f4b198aee45d16844886942"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9b5d1bc79e3f0d3f810ccee733e4f6615c5e583bac488620930b15e1ddc375"
    sha256 cellar: :any_skip_relocation, catalina:       "d636e8325ae54822e9c3c398c8779e4f94d01429fb4fd2bfd6dea81272eeb76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146dfc0a5bb5751569d81f71e613b886c6dfed2e42cbff1e9151263bbeb7bbaa"
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
