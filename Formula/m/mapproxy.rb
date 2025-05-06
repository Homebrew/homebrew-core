class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  # `mapproxy.org` is 404, upstream bug report, https://github.com/mapproxy/mapproxy/issues/983
  homepage "https://github.com/mapproxy/mapproxy"
  url "https://files.pythonhosted.org/packages/3f/bd/c53da466ea00a958bd916f581b044ff8bfeaa326e7c286eebf8876c90539/mapproxy-4.1.1.tar.gz"
  sha256 "dbeb1ba315803fafc43cb1c20fb8c0f5be35cb1d5c3aec4ca48b339a7f32486a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48c51650310101e3dddd061ef1c1551c11dbc6662855579cee4aca65398e8aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "11fac67ac54f7f300ea1692b230a2813a8460ba730000d61bfe0a19e7453f9d2"
    sha256 cellar: :any,                 arm64_ventura: "4f8cb94468c7d59c8a571781a555b59694acea9413257771372d7d318681c832"
    sha256 cellar: :any,                 sonoma:        "867356cd84ea7224304f20880e00a6038e77ca992af7865de57f3b26420b76ef"
    sha256 cellar: :any,                 ventura:       "e29185f3960e626520849bc27032e0f7ab6c8803a5b1c2452cbd99a298e39c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9d07a24f205ee40a6725ac38b01034bac472eabeee4c0affbde4e54ae7ae9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799eabffb8695cb89b1eee8a2bffb68ab0b568c875166e97f7e045abf94d6eca"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
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
    url "https://files.pythonhosted.org/packages/0b/b3/52b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41/rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_path_exists testpath/"seed.yaml"
  end
end
