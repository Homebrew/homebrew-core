class OpenAdventure < Formula
  include Language::Python::Virtualenv

  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "https://gitlab.com/esr/open-adventure/-/archive/1.22/open-adventure-1.22.tar.bz2"
  sha256 "d3e48baee13fe953e041f1b8264580bf96bc893edee62586151de234350c3ccb"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a85e36b9ca1263f3c649ab8901c626948771987728870c9e06a1f5e739be23b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e3ba5f82737e3f2d69144e443a0cbb042cec9ed646c2e3648890d72d73085c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e0a54e27022d53946bf903de98e046ae26c63dde49dedd47ec50ca3d8bb284"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbd2aced4cdfcfcad1156dbb413876df209b802d8a57cf15380c003627f82dd4"
    sha256 cellar: :any,                 arm64_linux:   "1709022ce11a1790a14725e4c764d941c14583e768ddeb957e7ad3b9b41282cc"
    sha256 cellar: :any,                 x86_64_linux:  "5d5af052ec2e2dcb1fd4075320717f84863bffd2d8a276daeea972419aee93b1"
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
