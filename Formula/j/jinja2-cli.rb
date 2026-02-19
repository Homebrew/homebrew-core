class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/cc/47/7d9eb78491492a30d661387abeaf86e1a2b6a6da9d167897173ba4fdcce0/jinja2_cli-1.0.0.tar.gz"
  sha256 "e7dadec3f908602669b1518245c90a0c08bceecc2c40d35011e3bcb54bcdf52f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b528139b50bb29cf676845e237df5c3cdff7a17280b377d9513079607f338582"
    sha256 cellar: :any,                 arm64_sequoia: "52c17d029191c588d01d61db382a75c8b3ecfe2d9c920f6a21b2a51a168900f3"
    sha256 cellar: :any,                 arm64_sonoma:  "88fd33c859ccee78eec2be6a828798fb5a3dbdefc4bc7f63beedf761a1e7110f"
    sha256 cellar: :any,                 sonoma:        "4b49e0fcc8ac730c12d14a2de2d190497cf8e3c972f59cb166d05c0c047f5417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d631c54a86744ffa9848ab95a496749b06013296b8c52d078771d783ce73b4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4b2551085d23cb09309f3526f1e0903d67c72e72146dc686fffe0fce486563"
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
    url "https://files.pythonhosted.org/packages/6a/aa/917ceeed4dbb80d2f04dbd0c784b7ee7bba8ae5a54837ef0e5e062cd3cfb/xmltodict-1.0.2.tar.gz"
    sha256 "54306780b7c2175a3967cad1db92f218207e5bc1aba697d887807c0fb68b7649"
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
