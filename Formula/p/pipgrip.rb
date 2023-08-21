class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/ba/35/218a9340ea032fc402fee92acf487007311d47be5fc37824984e5d7eb83f/pipgrip-0.10.7.tar.gz"
  sha256 "4bbd2f83ad4da7df2c10a58da618bfba5ca411f8964934251b18ce8a2e70a07c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9826c4852baa46f6adac063c21383c1e629a868fb064f5c93d30688c960d36f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9dfb22853418ed4855b44a5355b7e4dfe65446d54a9e0ba532366603e7948bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82f4cda5d28bb0bd18f2e26edb08361d69ee16ec19c97003e435c8414f697b6b"
    sha256 cellar: :any_skip_relocation, ventura:        "7eada787bd9a0eb693cacdbcf662be087e34d16572d34a8acfcf4dc9caf8d863"
    sha256 cellar: :any_skip_relocation, monterey:       "c91cdf21c2b77dca34ab2153cba7459f7bc01c34a96221b0bbe0af84bca2e353"
    sha256 cellar: :any_skip_relocation, big_sur:        "199782851f01d04b0281f36e3bd830019834b87c6134e57db4840bbc248d4c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2041447cab66af568da532587374f354eea0bbd4fb7a7e0d01381b3c9e5932c"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/ed/20/560b2c0801762f3de73ce04dd20d50ec39c2cdae83f23b6ed81cc72c7558/anytree-2.9.0.tar.gz"
    sha256 "06f7bc294293da2755f4699cc5da5c92d9182a5cfae2842c83fb56f02bd427c8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
