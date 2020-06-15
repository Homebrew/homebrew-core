class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/8e/02/b338c2628676957da938aa5e62c5b085bca31ad2723c8c1f80b47cf85593/jc-1.11.6.tar.gz"
  sha256 "5672cc73e8037feda0621cbc41557a241e1272d6f21650251e9080d9fd43aaa0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e2692f8e4f9fec6919de95290e6ad986af61eae20b5cd5f6914f88d75c16002" => :catalina
    sha256 "7833ba2cb69b6665ac34f0e509839cca8c329934ff2dd7f04aafc27e6a1ce691" => :mojave
    sha256 "d38aadb509aa6a6944dae777bf99fe2ec7bcae308676f5f6832487525d8f9255" => :high_sierra
  end

  depends_on "python@3.8"

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "[{\"header1\": \"data1\", \"header2\": \"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
