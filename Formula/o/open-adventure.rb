class OpenAdventure < Formula
  include Language::Python::Virtualenv

  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "https://gitlab.com/esr/open-adventure/-/archive/1.21/open-adventure-1.21.tar.bz2"
  sha256 "8ddff48254f868999957bef5f9a1606140d8cacae4a4d87f676fd819876e57c6"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1e756daba18ba6acb0c2d8cb5ed79fb5cac368236cc721258ceed36c1c309ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346050e4b4607a2b6b8c1a7cfcc7637d65c7338e2c5a5b3dba17fe54b1f16933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c901cfdd624cdba01051559e5a8e8821ed8217c942f4f93b5b3d8512b4243cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fce249b0871056bb4f9dac69c8ca5f0c64be4ad05250cf5752f51f547342511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "400454c31641b59ca8ec560bb119463501d9734f47bf4f2f52af013fa2241afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b91344d5502ac8058a2ab367275a177da5e029edf4ee2d9a31068dade907beb"
  end

  depends_on "asciidoctor" => :build
  depends_on "libyaml" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

  uses_from_macos "libedit"

  pypi_packages package_name:   "",
                extra_packages: "pyyaml"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    venv = virtualenv_create(buildpath, "python3.14")
    venv.pip_install resources
    system venv.root/"bin/python", "./make_dungeon.py"
    system "make", "advent", "advent.6"
    bin.install "advent"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
