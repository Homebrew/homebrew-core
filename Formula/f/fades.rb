class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4ba1f34d9b0ea8d6e49e5ed4e459640eb0889c2ea8bd37fed8def5eb0be8b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ba1f34d9b0ea8d6e49e5ed4e459640eb0889c2ea8bd37fed8def5eb0be8b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ba1f34d9b0ea8d6e49e5ed4e459640eb0889c2ea8bd37fed8def5eb0be8b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "55dbc5b431725a5be9f9da921bb903db6ace6f7945db3d007956d94797c1f68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333d94af5b6c4482a7778980ffa4b0f5b7b9e0ea45b6f304067a249b17ed2bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "333d94af5b6c4482a7778980ffa4b0f5b7b9e0ea45b6f304067a249b17ed2bc2"
  end

  depends_on "python@3.14"

  def python3
    which("python3.14")
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
