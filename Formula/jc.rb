class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/ad/11/898a574b3bb132284dea1927ee35394d6b6153125260b70cd98af8bbf0bd/jc-1.11.1.tar.gz"
  sha256 "4de55cd708c1c470c07b663f62c3ec0090ee08ac9a97df14a9e6abff054f024f"

  bottle do
    cellar :any_skip_relocation
    sha256 "41e71f4f9fc3e10d282afb05873dcded021d04c2f8da15116b64c061d0c39937" => :catalina
    sha256 "e630df5735ca80e436e2939e8cd39aa7a6486e021a97dda42e223146903b7145" => :mojave
    sha256 "3c1330f6be780259785289c55d0bf9c7deada9abc433e711381802260e9f9166" => :high_sierra
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
