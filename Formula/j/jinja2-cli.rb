class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/91/b3/19afd8cfe9b6664fcc200befbc71a393cbbe343bb76a6acbeff1709d0c83/jinja2_cli-1.0.1.tar.gz"
  sha256 "cca3e59494558640af52add7b8636cfa82eba72871a21cbbdc0a6f2000a4e5b7"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e3a373d7f7fb80aec73ec26a334e742b179a7fbe5ad4ca5c300ea59168000824"
    sha256 cellar: :any, arm64_tahoe:       "0e9f93450d68abc7749d8f680a2c30e39c6cbc7f56654626e3927d58ed502848"
    sha256 cellar: :any, arm64_sequoia:     "04fee8f85a04a7dcaf3e7be7a92d6e5aac69984a5e687e83417afd51217861d5"
    sha256 cellar: :any, arm64_linux:       "f311cd7eda501eb59b74ffdff9cfaaff5739ffd9ba52c0c5ce6e8583647bd32c"
    sha256 cellar: :any, x86_64_linux:      "3435220927986ad31d224f97c098c71e4f13dd073c0b4ad40c1e83de4bdfacfd"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages package_name: "jinja2-cli[yaml,toml,xml]"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jinja2 --version 2>&1")

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
    template_variables_file.write <<~JSON
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
    JSON
    output = shell_output("#{bin}/jinja2 #{template_file} #{template_variables_file}")
    assert_equal expected_result, output
  end
end
