class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce9c6090ad9c8b8d6ab89fb8e811ba030133a0c42e685b7c638a3b4feb833798"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93ad54b122ef117d6ce4c83e3a6e3372af3315524d9f4411de1ef5f63099bb92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6635e353a8ef912a2eb2132cd65693b12b44d177b949ba79e08e95490110f8fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb9d9e7068a4d3b53a38ee438837c790b1531ee521fdbaf3872d4089c8a6e95a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e5212cf31379551bb59799d0321ccf41b9a8b5092d7b79c207aa26bc1c190b8"
    sha256 cellar: :any_skip_relocation, monterey:       "a3616563422a2812f992c1f418ed95de6c24b8192a1c414cf68da07ca98a06b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30949a201d481da6297635425b85d1ae346a1cff8a53c5644a07bad0ca9cd2fa"
  end

  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    ENV.append_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
      end
    end
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    (bin/"fades").write_env_script(libexec/"bin/fades", PYTHONPATH: ENV["PYTHONPATH"])

    man1.install buildpath/"man/fades.1"
    rm_f libexec/"bin/fades.cmd" # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
