class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ae23ce3e986aa461efc9dfbb017e62daf3d47bab6650455c64efa609c9a6561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ae23ce3e986aa461efc9dfbb017e62daf3d47bab6650455c64efa609c9a6561"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ae23ce3e986aa461efc9dfbb017e62daf3d47bab6650455c64efa609c9a6561"
    sha256 cellar: :any_skip_relocation, sonoma:        "21e8405e8b50121bf4d6d0a464265411208e394d764d3982e50a74caddb32176"
    sha256 cellar: :any_skip_relocation, ventura:       "21e8405e8b50121bf4d6d0a464265411208e394d764d3982e50a74caddb32176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c86e1370b14aac85b9df22c4d8ec002ebb01c24ee432d9a38efe625c6ae0c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c86e1370b14aac85b9df22c4d8ec002ebb01c24ee432d9a38efe625c6ae0c96"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.13"

  def python3
    which("python3.13")
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
