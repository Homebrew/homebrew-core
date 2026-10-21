class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/da/6b/d02503bba3a90fc333d6188b892554bcfccb30b6e3728086fa0fa4c2857f/overturemaps-1.0.2.tar.gz"
  sha256 "e92355dcc2961da0ce95ab9837a59f2d15bcc357be51d0c415ceab3d812fc97d"
  license "MIT"
  revision 1
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1197410527a2b02304f7b78e47741c22dc1297864c2650c3cbb980529c27c2cd"
    sha256 cellar: :any, arm64_tahoe:       "b07dfd9ae243c02b7b35cc0174174613fdb581d35c0c94fc235eaeae53a6d786"
    sha256 cellar: :any, arm64_sequoia:     "a046a37e5fee566701e977818989c0c22631ecf10519f85ae0e74db77891bf51"
    sha256 cellar: :any, arm64_linux:       "382adcc11cbe87560c52dfdada6288fabaf06ad452db23dc68e48c7b5bcd0fa2"
    sha256 cellar: :any, x86_64_linux:      "aba42503aa0ffcfe827f90f16c118a3b5ac3232233e8260301c25ae8562b8fa0"
  end

  depends_on "cmake" => :build  # for pyarrow
  depends_on "ninja" => :build  # for pyarrow
  depends_on "rust" => :build   # for orjson
  depends_on "apache-arrow"
  depends_on "geos"             # for shapely
  depends_on "numpy"
  depends_on "python@3.15"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: "numpy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/ec/34/17c34cb38e5d940e38f0f0d9fdfa0e8a506676409ea9b85aff7e3079f831/pyarrow-26.0.0.tar.gz"
    sha256 "0cccd36e00ea3afeb52ded61f2721ce71f604853d70c45365c58324eb773d6ae"
  end

  resource "pyfiglet" do
    url "https://files.pythonhosted.org/packages/c8/e3/0a86276ad2c383ce08d76110a8eec2fe22e7051c4b8ba3fa163a0b08c428/pyfiglet-1.0.4.tar.gz"
    sha256 "db9c9940ed1bf3048deff534ed52ff2dafbbc2cd7610b17bb5eca1df6d4278ef"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/f3/ab/924b6e202f796d270a3041a230151f7908db5ea48c74effe6f8023e9bd05/shapely-2.2.0.tar.gz"
    sha256 "e8865e553d874a1ec4a032057ea81fca9def37b188cd8fb550af3b3480b3f88c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
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
