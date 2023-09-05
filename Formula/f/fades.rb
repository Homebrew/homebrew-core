class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0b7a66d6d4d9b19bc3453d4cf84259779648837634149ca0ed482cb051e1787"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faaf390a5ced6e0f8591d82839d7e1dbfa1a3d81dda5df42dad37dc9ba59e860"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bebccd6c533872ab4aa5a3961ced0b0e5e9223621b6f2c7f185994aff468125"
    sha256 cellar: :any_skip_relocation, ventura:        "7e3a7c935370d3fe21d37788d09be37b6aafd043692706c3282b40b7b499427a"
    sha256 cellar: :any_skip_relocation, monterey:       "334fb96ed33d63b0b439a46f5b4ea00f8c73cd071fc9223ff5f8a4a6288c81f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "83399213117615c742b8caf868e8e4841b3d9711113ee11d29c465139191a355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee2d857138f7d8038bc46934a7e1f4bd517891f44b293014c8f0963e10b1f36"
  end

  depends_on "python@3.11"

  def python3
    which("python3.11")
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
