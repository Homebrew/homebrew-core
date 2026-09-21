class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/da/6b/d02503bba3a90fc333d6188b892554bcfccb30b6e3728086fa0fa4c2857f/overturemaps-1.0.2.tar.gz"
  sha256 "e92355dcc2961da0ce95ab9837a59f2d15bcc357be51d0c415ceab3d812fc97d"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b546c09aa45edff2122322bc5ba351f6626c433d9d4b58257e1d173a39cb1581"
    sha256 cellar: :any, arm64_tahoe:       "da396c9a1d123c727224653af61668f8ee746bd25fddbbe5f6f906e2cfd63155"
    sha256 cellar: :any, arm64_sequoia:     "4e29fec7adec9ec0f59a43b3600173da12c4427372c5db3c48449ba2a9036e38"
    sha256 cellar: :any, arm64_sonoma:      "cdecdb7d492c274f9394a92beebc316b2189690a6821b7e055f0b57b8e278e34"
    sha256 cellar: :any, sonoma:            "d15beb475498bc09d3514d2c129262a36df44a105f9a86e17ca151306dfbc04d"
    sha256 cellar: :any, arm64_linux:       "1d85438ed32e08885197ed250d7cb2aeca85ef93b13277d1a28725479d9ad0ad"
    sha256 cellar: :any, x86_64_linux:      "ee2d94999882b84ad727d330fef875b23f25c9e7bd380a07760ad769ccbb1a07"
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
    url "https://files.pythonhosted.org/packages/0f/f3/742fb1f62b825f2c010697eaf4e828004bc2a81e7e806666989c132c7c42/orjson-3.12.0.tar.gz"
    sha256 "d14203fb1aae2ad9b3d52f8a0e82aeb10197ef1c9bc61da7f358bd70b00123d5"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/3d/e3/27f57f80141379d60defe6703eb50a707325706f07fedfd1312c7a751995/pyarrow-25.0.1.tar.gz"
    sha256 "9150a83248bfed9813ea3c3af74c3856c1984d444aa28e58bf7733b9750ddf6a"
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
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  def install
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
