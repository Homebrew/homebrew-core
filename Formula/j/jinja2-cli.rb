class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/cc/47/7d9eb78491492a30d661387abeaf86e1a2b6a6da9d167897173ba4fdcce0/jinja2_cli-1.0.0.tar.gz"
  sha256 "e7dadec3f908602669b1518245c90a0c08bceecc2c40d35011e3bcb54bcdf52f"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "157e6a406008cdc0be4df1286a88c2c950a37aa9d3c1d91b132aa51618f3bdd3"
    sha256 cellar: :any,                 arm64_sequoia: "5ca7098ef9032def0541e94247d55465e1da685d0e96485bd92b7b91f91b8fd4"
    sha256 cellar: :any,                 arm64_sonoma:  "2317ec1250bc8823be5988d3d033e1db2809984f0ee28fdf678e663e67ff0935"
    sha256 cellar: :any,                 sonoma:        "ff49c01c6798c5bb2e9dd9079248450d156b24c55a0ec975587521233aaeb829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b963413db8832b24396afebe937648fbcd6e2135d10329ed324df7600ec8fdf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c284b0eee62b02969ce0b167081fd1b77f0d50647c32d17f65b7173b6d61dfd7"
  end

  depends_on "rust" => :build # for uv-build backend
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
    url "https://files.pythonhosted.org/packages/6a/aa/917ceeed4dbb80d2f04dbd0c784b7ee7bba8ae5a54837ef0e5e062cd3cfb/xmltodict-1.0.2.tar.gz"
    sha256 "54306780b7c2175a3967cad1db92f218207e5bc1aba697d887807c0fb68b7649"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jinja2 --version")

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
