class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/e6/f5/daead7fd8ef3675ce55f4ef66dbe3287b0bdd74315f6b5a57718a020570b/pyqt_builder-1.16.4.tar.gz"
  sha256 "4515e41ae379be2e54f88a89ecf47cd6e4cac43e862c4abfde18389c2666afdf"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3823ba09e3c991b01c02636c6b2adc4836fb822f7c22c0091e79fc588ffc841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a061675692c46691e65d34a29710cb64d5e6e9d50cb028cea6338ff9f258c011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a061675692c46691e65d34a29710cb64d5e6e9d50cb028cea6338ff9f258c011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a061675692c46691e65d34a29710cb64d5e6e9d50cb028cea6338ff9f258c011"
    sha256 cellar: :any_skip_relocation, sonoma:         "32114b67ed9ac121368a6c251b757c15eb5fef6bbc0df59f2d242fce12e6befe"
    sha256 cellar: :any_skip_relocation, ventura:        "32114b67ed9ac121368a6c251b757c15eb5fef6bbc0df59f2d242fce12e6befe"
    sha256 cellar: :any_skip_relocation, monterey:       "844537780bbb59836b71220ab4738f8acfecf1c159b6257005eef4a1b74a9485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9c9bf09d3044caf12c5f52625afb83ef1f58ce997d0de9c81ede1eb2f6e9eb"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/6e/52/36987b182711104d5e9f8831dd989085b1241fc627829c36ddf81640c372/sip-6.8.6.tar.gz"
    sha256 "7fc959e48e6ec5d5af8bd026f69f5e24d08b3cb8abb342176f5ab8030cc07d7a"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
