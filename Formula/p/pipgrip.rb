class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/fb/dc/f89b89e72e541bb5ffa25cbaf1f9c92d2c2187644c8972772aafb7bf0009/pipgrip-0.10.13.tar.gz"
  sha256 "f481ef054c37036d334ca6f4b8608c1ca8a113e02e011276b540f1558dc394ba"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70bf0274fec9ce3d2d530b046435835cae732fed8b3f5ab031708c93677ea949"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70bf0274fec9ce3d2d530b046435835cae732fed8b3f5ab031708c93677ea949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70bf0274fec9ce3d2d530b046435835cae732fed8b3f5ab031708c93677ea949"
    sha256 cellar: :any_skip_relocation, sonoma:         "f954b75c0b821dd12d09647646d66d26b71bd33098d6effd0d6274c58e492d1a"
    sha256 cellar: :any_skip_relocation, ventura:        "f954b75c0b821dd12d09647646d66d26b71bd33098d6effd0d6274c58e492d1a"
    sha256 cellar: :any_skip_relocation, monterey:       "f954b75c0b821dd12d09647646d66d26b71bd33098d6effd0d6274c58e492d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf7e1d84cb65b66de306cf3617268a17508a75943ba5b42bade5807fd328ca5"
  end

  depends_on "python@3.12"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b8/d6/ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69/wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
