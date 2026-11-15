class Darker < Formula
  include Language::Python::Virtualenv

  desc "Apply Black formatting only in regions changed since last commit"
  homepage "https://github.com/akaihola/darker"
  url "https://files.pythonhosted.org/packages/df/78/ad6af1661c2eca0ec69b7ff7c99d95dcae29c5e0071c7ebc98e6670f4663/darker-3.0.0.tar.gz"
  sha256 "eb53776f037fcf42b1f5a56f62fb841cd871d95a78a388536dc91dc4355ce8bb"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7f1211b15f64ec6e8c2e65f4b208f5823ab8e0b366c45562ed0c3a0d02a387e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5dd4ade2999756f7691d45dbfcf9d3710532de0c1e9326836783dfa4042ee8d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "028ff23bc9d07140746b474147f9781040a3b7c4ff4c86e773e141487ec3ae53"
    sha256 cellar: :any,                 arm64_linux:       "f669b78d7fc7b9749c4680c58a83ba17818dd3a627ed0315e2fb32a27584eb2f"
    sha256 cellar: :any,                 x86_64_linux:      "1e456644ffce05e88752c1fa8aa4209477d957e39549bbb4f5913e3cb89b61d3"
  end

  depends_on "rust" => :build
  depends_on "python@3.15"

  pypi_packages package_name: "darker[black]"

  resource "black" do
    url "https://files.pythonhosted.org/packages/f8/65/a9611a6ec0a8c88d86e59385da02d68d9533f7e86a05913d20c67be54029/black-26.10.1.tar.gz"
    sha256 "5f9f83beae62437e060dafd53d7f1fc327e3d3494f74d72ee5c2b73eb90fc4e7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "darkgraylib" do
    url "https://files.pythonhosted.org/packages/33/3f/e07f4a048a3d73b97311274c307d13d26a59c0c5cb6ac3388e343a03543c/darkgraylib-2.4.1.tar.gz"
    sha256 "032df9cf2a545573f4492a9c03cd70ea6264ebddaabf973ea02a02fdb6aed6f8"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darker --version")

    (testpath/"darker_test.py").write <<~PYTHON
      print(
      'It works!')
    PYTHON
    system bin/"darker", "darker_test.py"
    assert_equal 'print("It works!")', (testpath/"darker_test.py").read.strip
  end
end
