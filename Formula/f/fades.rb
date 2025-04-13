class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec005bf0dac48b9c97017dbfbaff8f71bea5881b82a4125b6832f42b295ab388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec005bf0dac48b9c97017dbfbaff8f71bea5881b82a4125b6832f42b295ab388"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec005bf0dac48b9c97017dbfbaff8f71bea5881b82a4125b6832f42b295ab388"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5ca7bbe287a104d636ae776d190dd945731becd56ae3b16db7b43f56b6bac50"
    sha256 cellar: :any_skip_relocation, ventura:       "d5ca7bbe287a104d636ae776d190dd945731becd56ae3b16db7b43f56b6bac50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286e34dae97f60412d06e4d022a52156a0a17f70449e8240297772904a3dc193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dbae2733a6c7db55b8d0c89009067727f8a8a4081739e815e8d874973ca9645"
  end

  depends_on "python@3.13"

  def python3
    which("python3.13")
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
    rm(libexec/"bin/fades.cmd") # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
