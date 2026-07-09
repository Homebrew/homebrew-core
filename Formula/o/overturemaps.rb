class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/36/fc/5b779bf6df4b3b868c26a0ca2d54af2700e630ebdd89d224bd51f3684455/overturemaps-1.0.1.tar.gz"
  sha256 "c8a975dd8f64442187ce8a9e64840469cfcfac1c930ad09015acfcb1481e548b"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea8fe9cc79c41799f38d08cdfeb199eb892dda50a3d63dbaf4c744c85d01578e"
    sha256 cellar: :any, arm64_sequoia: "9d84384d2e9f85c464e8bc8c16d17bb9bcbc9be78a0be1124bbdd93474cbb2c2"
    sha256 cellar: :any, arm64_sonoma:  "d3e8fa6853160f20cf1a0a922ad73c71ead3753bb0b7cb53dfc507b5562f29f5"
    sha256 cellar: :any, sonoma:        "b4e344b041d90e516082d2c98604d8a8e8b54f9e27664b0be642d6f8b58fdb6d"
    sha256 cellar: :any, arm64_linux:   "6345e239120410e97af213dc2632bab3a2fadea9b6e7c32efa02fc4415386828"
    sha256 cellar: :any, x86_64_linux:  "ddfb797cf43ab539127800c79585c440df233b5a2537c9c36f0499f32bc28f65"
  end

  depends_on "cmake" => :build  # for pyarrow
  depends_on "ninja" => :build  # for pyarrow
  depends_on "rust" => :build   # for orjson
  depends_on "apache-arrow"
  depends_on "geos"             # for shapely
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: "numpy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/7e/0c/964746fcafbd16f8ff53219ad9f6b412b34f345c75f384ad434ceaadb538/orjson-3.11.9.tar.gz"
    sha256 "4fef17e1f8722c11587a6ef18e35902450221da0028e65dbaaa543619e68e48f"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/91/13/13e1069b351bdc3881266e11147ffccf687505dbb0ea74036237f5d454a5/pyarrow-24.0.0.tar.gz"
    sha256 "85fe721a14dd823aca09127acbb06c3ca723efbd436c004f16bca601b04dcc83"
  end

  resource "pyfiglet" do
    url "https://files.pythonhosted.org/packages/c8/e3/0a86276ad2c383ce08d76110a8eec2fe22e7051c4b8ba3fa163a0b08c428/pyfiglet-1.0.4.tar.gz"
    sha256 "db9c9940ed1bf3048deff534ed52ff2dafbbc2cd7610b17bb5eca1df6d4278ef"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4d/bc/0989043118a27cccb4e906a46b7565ce36ca7b57f5a18b78f4f1b0f72d9d/shapely-2.1.2.tar.gz"
    sha256 "2ed4ecb28320a433db18a5bf029986aa8afcfd740745e78847e330d5d94922a9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/87/d7/0535a28b1f5f24f6612fb3ff1e89fb1a8d160fee0f976e0aa6803862134b/tqdm-4.68.3.tar.gz"
    sha256 "00dfa48452b6b6cfae3dd9885636c23d3422d1ec97c66d96818cbd5e0821d482"
  end

  def install
    python3 = "python3.14"
    numpy_include = formula_opt_lib("numpy")/Language::Python.site_packages(python3)/"numpy/_core/include"
    geos_include = formula_opt_include("geos")
    geos_lib = formula_opt_lib("geos")

    ENV.prepend "CFLAGS", "-I#{numpy_include} -I#{geos_include}"
    ENV.prepend "LDFLAGS", "-L#{geos_lib}"

    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"overturemaps", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overturemaps --version")
    output = shell_output("#{bin}/overturemaps download 2>&1", 2)
    assert_match "Missing option", output
  end
end
