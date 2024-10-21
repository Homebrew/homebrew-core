class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/cf/76/54e0964e2974becb673baca69417b6c6293e930d4ebcf2a2a68c1fe9704a/bpython-0.24.tar.gz"
  sha256 "98736ffd7a8c48fd2bfb53d898a475f4241bde0b672125706af04d9d08fd3dbd"
  license "MIT"
  revision 6
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b360e10d30c6ee1b0ef0bf60b8245731f2202b794dee9c20625191dc4f5ae63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7750a5fc32efbc4ec1d8658eb91db4b3f657747e02252dc7ca6904f0bf59bf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d4e7d7cad4d6d74e7f704ce6d5fce6dee9f91bd90d627a675a27f3825c24668"
    sha256 cellar: :any_skip_relocation, sonoma:        "2197161d78fa3b89c3806645446ce4a787d384bb9277026589cdbf6a4e3988b3"
    sha256 cellar: :any_skip_relocation, ventura:       "1a5ff5d5e133a315c19dddf9cb43a2e78e9c43fe822acf1d2f7f444543e27171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64174373804d35a9235b4d7ee423c887bd122dec1b901a66a6f4e1172ed45767"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/53/d2/ea91db929b5dcded637382235f9f1b7d06ef64b7f2af7fe1be1369e1f0d2/curtsies-0.4.2.tar.gz"
    sha256 "6ebe33215bd7c92851a506049c720cca4cf5c192c1665c1d7a98a04c4702760e"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/95/e3/275e359662052888bbb262b947d3f157aaf685aaeef4efc8393e4f36d8aa/cwcwidth-0.1.9.tar.gz"
    sha256 "f19d11a0148d4a8cacd064c96e93bca8ce3415a186ae8204038f45e108db76b8"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/2f/ff/df5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46/greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def python3
    which("python3.13")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/site_packages
    ENV.prepend_path "PYTHONPATH", libexec/site_packages
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
