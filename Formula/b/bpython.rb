class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/cf/76/54e0964e2974becb673baca69417b6c6293e930d4ebcf2a2a68c1fe9704a/bpython-0.24.tar.gz"
  sha256 "98736ffd7a8c48fd2bfb53d898a475f4241bde0b672125706af04d9d08fd3dbd"
  license "MIT"
  revision 3
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "017bfd24c25e0df5fd21862f36fba230e5ed709dba05ee9e82b0c3f852edff68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251a84d93420a97f23178c545aabe6865d0844110f583f4a9bb41ad9b5e8dba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dabc48c6b5c56709d2690854ae34effe61566fba1455b2190c115cc6a2b6d875"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bdd48284538a714df46cba3c10314d0eb1bcbb9645b198b976345a0bf7ac931"
    sha256 cellar: :any_skip_relocation, ventura:        "5a42aa0f43bf441f2ecf3ed279886e075704f638015a29731b5d6255df0dece7"
    sha256 cellar: :any_skip_relocation, monterey:       "ccb7aa00e599c13f7313946c965c9def5ff3770ee0cc75315e5edabf2da3bf9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3670811e300f190b8a8d85a2be735b6dab58b5d4b4be6147ad7a5f3f2a869e"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/b6/02/47dbd5e1c9782e6d3f58187fa10789e308403f3fc3a490b3646b2bff6d9f/greenlet-3.0.0.tar.gz"
    sha256 "19834e3f91f485442adc1ee440171ec5d9a4840a1f7bd5ed97833544719ce10b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def python3
    which("python3.12")
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
