class OpenAdventure < Formula
  include Language::Python::Virtualenv

  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.20.tar.gz"
  sha256 "88166db3356da1a11d6c5b9faa0137f046e6eb761333c8d40cb3bcab9fa03e4a"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5cd8f69998d91913b55151dd6d546ad6ae558913b5691a446313bb7c479abd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a87d0c7a7e99a6170f9e899c298109ad6443bd4b1fefe8efbbcf68c245c5878"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb42895c9ea5740634c62e6c16f1680cd1f640b0c0a00cab5a6d3be53e92b039"
    sha256 cellar: :any_skip_relocation, sonoma:        "703624eecbc0d021d1ea47e49738a074fb7f0f973d5b1b013c7532dd8da2ec75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11986ede6b55b722c796c6e80f3eed1ac1fa3d4757b3dbc7a04a1df37f509e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0aa4f90ca96e69a747ffa5e90d2f8388248c077f0c5f9154322f8df690bf048"
  end

  depends_on "asciidoc" => :build
  depends_on "libyaml" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    venv = virtualenv_create(buildpath, "python3.14")
    venv.pip_install resources
    system venv.root/"bin/python", "./make_dungeon.py"
    system "make"
    bin.install "advent"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
