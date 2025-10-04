class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/08/9a/a2141736315337d427310b0d51759b67f56aef540ca3f540cad890685a54/mapproxy-5.1.1.tar.gz"
  sha256 "df7dc32a02f8cd280b541d1ea5e7b0b0f0a4d1f3b7ca173bfad4410cec163389"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34b4ef1b2365dc18c40bdc4aab52aec7d86edce40398da39a565a48e71e0f9f8"
    sha256 cellar: :any,                 arm64_sequoia: "a365482cae7fcaba7d32acb6fabed5de75a838bed3c2fd4ede0d60d0e02456f7"
    sha256 cellar: :any,                 arm64_sonoma:  "4aca8861d8eb4ea70851061be2d7d47701e3e4e2f4f5fd14cf80105344b23a47"
    sha256 cellar: :any,                 sonoma:        "b7f1bca3d9aedcfdc2f1d9323a37882c33f412df585eab9227505db093f1ba7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e71728068699422f42bd706a364be43d9eb769090daa4442baace77ae115c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c673b4996b47c646ca4ca5b84a6d1d40b255f1b8b07870dc5a3771463c80788"
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
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/04/90/67bd7260b4ea9b8b20b4f58afef6c223ecb3abf368eb4ec5bc2cdef81b49/pyproj-3.7.2.tar.gz"
    sha256 "39a0cf1ecc7e282d1d30f36594ebd55c9fae1fda8a2622cee5d100430628f88c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4d/bc/0989043118a27cccb4e906a46b7565ce36ca7b57f5a18b78f4f1b0f72d9d/shapely-2.1.2.tar.gz"
    sha256 "2ed4ecb28320a433db18a5bf029986aa8afcfd740745e78847e330d5d94922a9"
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
