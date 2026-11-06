class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/d9/21/6ac72a357c1fc68f9ed7aeb7f3918915a285aa5f751bad12e58594ef3687/overturemaps-1.0.3.tar.gz"
  sha256 "cb194ddf8ad355952cf9f9b1b6cbceaede44c85ea7e7e84131c4ac182d64a267"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "75bac3d3ed8c3f02708f5daed997d231f5c3411950a6b3a32ff6a48b5bd122b1"
    sha256 cellar: :any, arm64_tahoe:       "f899b79e6f53e45afd06821269b940e75ce069c981d84835d7ed57a495059299"
    sha256 cellar: :any, arm64_sequoia:     "53102a1e2e563ef52d351d8b320d80d0b542d3ff584faea6992b461d2a4abe2d"
    sha256 cellar: :any, arm64_linux:       "deb6b5d546bdba0af7ebe18a8777b2e59cfdc771bf74c8d4790fe2e570d51e66"
    sha256 cellar: :any, x86_64_linux:      "e809b9117f2796abf4fcb6a1d8a930b5e1ed2d34a9e724df8d45439d037215e9"
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
    url "https://files.pythonhosted.org/packages/bc/5e/9cb2a56d5e293aab4e2fbecc5b0620d93227d66b8d5a63c554c31e1f80fe/pyarrow-26.0.1.tar.gz"
    sha256 "93affcbd8a343e98dc19e9ec8fe17271ebf8fe98102d8b7454175074409f8b72"
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
