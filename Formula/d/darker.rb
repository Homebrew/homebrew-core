class Darker < Formula
  include Language::Python::Virtualenv

  desc "Apply Black formatting only in regions changed since last commit"
  homepage "https://github.com/akaihola/darker"
  url "https://files.pythonhosted.org/packages/df/78/ad6af1661c2eca0ec69b7ff7c99d95dcae29c5e0071c7ebc98e6670f4663/darker-3.0.0.tar.gz"
  sha256 "eb53776f037fcf42b1f5a56f62fb841cd871d95a78a388536dc91dc4355ce8bb"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c892185978be30469bd0869f46c9682343e2e993238932fbb5e58431b57a527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374b3a3442372a649f98cb35507910f6410186f47c77caa87f1111bfd5c30862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b38b2b2816e15771b7e01b345c2a56fc46f8a35cf5321a069a80734a191658dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d0cbc934db0844321c6e57bcf7cb065f84937368ea481fd0d44607929d4af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67dd1c58f8618e3540ba09a5e4bb918c82ffb1a198de2b2357ce451fae802b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a90863d314ae33c6952fdaa2a6f81ee6370163afcba24b9d7a56e01cd0bf236"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "darker[black]"

  resource "black" do
    url "https://files.pythonhosted.org/packages/e1/c5/61175d618685d42b005847464b8fb4743a67b1b8fdb75e50e5a96c31a27a/black-26.3.1.tar.gz"
    sha256 "2c50f5063a9641c7eed7795014ba37b0f5fa227f3d408b968936e24bc0566b07"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
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
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
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
