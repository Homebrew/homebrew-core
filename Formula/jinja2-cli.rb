class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c89ce92bc208e5f24341a95407f0312fb75cefc1acf6cd5368f43172e76f6f14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "230eccf449b435136ed4dcb8e4a95d398bcf36759ce3c2acaab491175b491a6f"
    sha256 cellar: :any_skip_relocation, monterey:       "7a6b5d66be6e82439b72b1ed29bfba93351b37a297be9f79d991b1a124565a9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0c90b76c61f305446f010e9ac002cf51503d2c352c9aa7bbc1decce82d70393"
    sha256 cellar: :any_skip_relocation, catalina:       "572b62c21bb12fb4929a9f53f857f4b7320bccfe659fe76ac683fbbbf685b00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d72d1ad9c82c2ea561e2933037445de5158a5dc678f0017be93a20b00c92cd"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/jinja2 --version")
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/jinja2 --version\"")
    end
    assert_match version.to_s, output
    expected_result = <<~EOS
      The Beatles:
      - Ringo Starr
      - George Harrison
      - Paul McCartney
      - John Lennon
    EOS
    template_file = testpath/"my-template.tmpl"
    template_file.write <<~EOS
      {{ band.name }}:
      {% for member in band.members -%}
      - {{ member.first_name }} {{ member.last_name }}
      {% endfor -%}
    EOS
    template_variables_file = testpath/"my-template-variables.json"
    template_variables_file.write <<~EOS
      {
        "band": {
          "name": "The Beatles",
          "members": [
            {"first_name": "Ringo",  "last_name": "Starr"},
            {"first_name": "George", "last_name": "Harrison"},
            {"first_name": "Paul",   "last_name": "McCartney"},
            {"first_name": "John",   "last_name": "Lennon"}
          ]
        }
      }
    EOS
    output = shell_output("#{bin}/jinja2 #{template_file} #{template_variables_file}")
    assert_equal output, expected_result
  end
end
