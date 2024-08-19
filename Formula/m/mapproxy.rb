class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/c8/c5/dd0f9e5bc140f6078bd7a9f62e90f2ac8b7d23e557d939283f2380e19e1a/MapProxy-2.2.0.tar.gz"
  sha256 "d851207dda3c8bf479954d06e75e3325c68845ef32eb4566d231ce0446a81302"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81225e77d50fde6fe0389ab03e1e0301c57655585965546021213026595eb13a"
    sha256 cellar: :any,                 arm64_ventura:  "c2156e48e4b818a38bbaafba6ef291b5a73eb80fde45fa641994c09a4f63716c"
    sha256 cellar: :any,                 arm64_monterey: "0b5b1b5984a9a176fab740cc35908ed55d18573ddf2e4406c0950df8159bd36c"
    sha256 cellar: :any,                 sonoma:         "9a54ac95a0da1f9526e48e8eaba308d80a12cb102105670026009103f93adad2"
    sha256 cellar: :any,                 ventura:        "a5133cc27e5444498808f2b29f65803db2725512a67b5a98e6a793ae7741a8fa"
    sha256 cellar: :any,                 monterey:       "152ae74f05a51bc4c38c74114a47bf4e15bdb9ec53d82b10f57cfb5d508f9c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50c52ddb2c83c33a137864f6962d26cd9e261a0753980a34e8add9b6b91e27b"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2f/fe/5217efe981c2ae8647b503ba3b8f55efc837df62f63667572b4bb75b30bc/rpds_py-0.19.1.tar.gz"
    sha256 "31dd5794837f00b46f4096aa8ccaa5972f73a938982e32ed817bb520c465e520"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
