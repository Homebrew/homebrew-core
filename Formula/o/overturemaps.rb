class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/d0/65/8327d6961f9e5f526e899d1db376c277094c36f20f23d1a278b66e6939a6/overturemaps-1.0.0.tar.gz"
  sha256 "2fb9f5d37e2a215259cc1994ddcdf3f312f54f0491aee5457ce48aa9c0514240"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cd42ccd1a917355e812f5a380665b0308f2bb9e5e78a5e4e4ac36ba33acd2488"
    sha256 cellar: :any,                 arm64_sequoia: "3124deed456b34697a153c5e5ff46504d71054ca2feacb17ab61e18faf6030db"
    sha256 cellar: :any,                 arm64_sonoma:  "88635d2797647da59448dd015a483b6864301780502692b1d7198e1005103682"
    sha256 cellar: :any,                 sonoma:        "1bd3e2b9c55ca6e22c43cf0eede150c9ddfb50a8efe591ef99fdbccd0db03fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32e62456cd1deb519a245d10bf7bb7ec2e7169c240d21eca3fc1dfe7408316fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8135573f40797cad90933debd0446c610eec33fc6c8b895dedc6a4656d0e41e0"
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
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
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
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    python3 = "python3.14"
    numpy_include = Formula["numpy"].opt_lib/Language::Python.site_packages(python3)/"numpy/_core/include"
    geos_include = Formula["geos"].opt_include
    geos_lib = Formula["geos"].opt_lib

    ENV.prepend "CFLAGS", "-I#{numpy_include} -I#{geos_include}"
    ENV.prepend "LDFLAGS", "-L#{geos_lib}"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overturemaps --version")
    output = shell_output("#{bin}/overturemaps download 2>&1", 2)
    assert_match "Missing option", output
  end
end
