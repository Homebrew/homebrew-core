class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/34/64/3883ba519fd547f2f3bd376a1d72137f26ccd7cfea098368d0c180fd2c1a/mapproxy-5.0.0.tar.gz"
  sha256 "c6d11ace3fd416320b5a872c8d0d45c488d093cf17af27e499ea25197bba6bde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8df2d554d13f6d38d8fa8f5a6b3e75df9572ff6f212ba908bdf233233bb15a30"
    sha256 cellar: :any,                 arm64_sonoma:  "0705b4099aa61c5496c4dc4d21a29d8225d7ad053953c1b2180a26a540999e79"
    sha256 cellar: :any,                 arm64_ventura: "4d08f167ea6648fd2472b8afb411eb5cb534ac4cf8d4bc9b5feaa4c7340175de"
    sha256 cellar: :any,                 sonoma:        "7c7f7a7c1ac0c4f5af00abbf6a0f22b1851d3a5f3116106463c7fd121bda40ce"
    sha256 cellar: :any,                 ventura:       "864b9e03dd1d214ed7783dbcffe5358726694e4d3a4bf1eee22ae1fbbd178e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "188ef23f667e023b76ef8563429ccd13c0fdc09fd909de7b5e1de5e57bff52ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba03d00c33d36df33ad865048b9edc8e6352d18a6c1811d8be79623a9ecbdb4a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "geos" # for shapely
  depends_on "libyaml"
  depends_on "numpy" # for shapely
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build # for shapely
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/bf/d3/1cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177/jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/67/10/a8480ea27ea4bbe896c168808854d00f2a9b49f95c0319ddcbba693c8a90/pyproj-3.7.1.tar.gz"
    sha256 "60d72facd7b6b79853f19744779abcd3f804c4e0d4fa8815469db20c9f640a47"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/8c/a6/60184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921/rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/ca/3c/2da625233f4e605155926566c0e7ea8dda361877f48e8b1655e53456f252/shapely-2.1.1.tar.gz"
    sha256 "500621967f2ffe9642454808009044c21e5b35db89ce69f8a2042c2ffd0e2772"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def python3
    "python3.13"
  end

  def install
    numpy_include = Formula["numpy"].opt_lib/Language::Python.site_packages(python3)/"numpy/_core/include"
    geos_include = Formula["geos"].opt_include
    geos_lib = Formula["geos"].opt_lib

    ENV.prepend "CFLAGS", "-I#{numpy_include} -I#{geos_include}"
    ENV.prepend "LDFLAGS", "-L#{geos_lib}"

    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_path_exists testpath/"seed.yaml"
  end
end
