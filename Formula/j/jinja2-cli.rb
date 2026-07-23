class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/91/b3/19afd8cfe9b6664fcc200befbc71a393cbbe343bb76a6acbeff1709d0c83/jinja2_cli-1.0.1.tar.gz"
  sha256 "cca3e59494558640af52add7b8636cfa82eba72871a21cbbdc0a6f2000a4e5b7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "684ea655961fe3fa1d9cb29bc9e9e37953a4e4e40f0cd77ebc9b53429f21bb16"
    sha256 cellar: :any,                 arm64_sequoia: "78cd8059e59ebb5b31c076281b2119a205caf82a08fb4645d9e02493d35670f8"
    sha256 cellar: :any,                 arm64_sonoma:  "c589aaf5e1a7f329112a88ec10114ed85551469b69645c28d5deae854d2a3c4b"
    sha256 cellar: :any,                 sonoma:        "cd31e70f879e729e8c0bcc0b70be096e1377d79f2d3429e3f3b399b611ae5009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c858f22dca555fc3d6a213c7544cb5f29f8713c3c20183fe908b5205499f37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d69fb38f48f16b2061722212f05ccbcb9236040b3211c44f46fcecfc3b18fd84"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "jinja2-cli[yaml,toml,xml]"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
