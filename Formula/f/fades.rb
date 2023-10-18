class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d20c265fd4cb8fdff88360013130723a83475006679c99d54b53aa1aa75d81f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fafd322dc2f3efee8a9cf01e6a35cc8bccc2c046daafb0fd1203c60918c0a76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f186b81297c27392483d9b130d1b25d0915cd2a67be22c1d7e0764a11c191e36"
    sha256 cellar: :any_skip_relocation, sonoma:         "47cab175dfb2758c732b496793b34de802bb7fe17119f8ea7358278cf39b47ed"
    sha256 cellar: :any_skip_relocation, ventura:        "11020613c15a143f540f3e3eec277887aed1f17d16af9d413cc088dccdc0a599"
    sha256 cellar: :any_skip_relocation, monterey:       "eec108d1c5d1f66543a7e80c90d9cc8b5679332f75885d94e70da3e8a94e8f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a94986ec051694e5472114067a7fd4cb4b764aebd0a3b84a709b25443d2498f5"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    man1.install buildpath/"man/fades.1"
    rm_f bin/"fades.cmd" # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
