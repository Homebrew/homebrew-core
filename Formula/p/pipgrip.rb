class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/fb/dc/f89b89e72e541bb5ffa25cbaf1f9c92d2c2187644c8972772aafb7bf0009/pipgrip-0.10.13.tar.gz"
  sha256 "f481ef054c37036d334ca6f4b8608c1ca8a113e02e011276b540f1558dc394ba"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ddelange/pipgrip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426d23066076ebb711fa9e77801de7fef0b5b01dd5fffd0ea4ca5677f4c21073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "426d23066076ebb711fa9e77801de7fef0b5b01dd5fffd0ea4ca5677f4c21073"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "426d23066076ebb711fa9e77801de7fef0b5b01dd5fffd0ea4ca5677f4c21073"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde391216cf4a1970104656ff5121675a4dd3884e4ee9a05357fb17d7d9565c2"
    sha256 cellar: :any_skip_relocation, ventura:       "dde391216cf4a1970104656ff5121675a4dd3884e4ee9a05357fb17d7d9565c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd2b4e3eb1406b98ae66d6cd22ec0e8d1cd18361043160554ec23f36ae478e5"
  end

  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b7/a0/95e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813/wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
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
