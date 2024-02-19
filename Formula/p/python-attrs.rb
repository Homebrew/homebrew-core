class PythonAttrs < Formula
  desc "Python Classes Without Boilerplate"
  homepage "https://www.attrs.org/en/stable/"
  url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
  sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20be179c9701db7b77cbd35ebe44c7de25faa2d1a531e8d094e3d852538f7919"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94ea337879d2020f1b14df562f34b807888109806ec156dd3181025f3cb7cbdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f685bb30c970ecb58f9926970314f99299d452202acfced7994662d8fddb353"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4d629a9c30ded8e953116c7e8ce0067396964dcb26fc83f49511a0d76da54e8"
    sha256 cellar: :any_skip_relocation, ventura:        "4986c5771c00cdd49390f47dac083bed556585f5ee0153fc8c7c074e90c77d38"
    sha256 cellar: :any_skip_relocation, monterey:       "6f889272d5e697997a267923aead840fb321cb79b404ba6355befd16e6b1229a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe413106fbd08d04704f0920b35e28af44ba63d484a854cd09a6983283a416e"
  end

  depends_on "python-hatch-fancy-pypi-readme" => :build
  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import attrs"
    end
  end
end
