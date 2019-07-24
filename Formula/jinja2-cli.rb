class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/23/67/6f05f5f8a9fc108c58e4eac9b9b7876b400985d33149fe2faa87a9ca502b/jinja2-cli-0.7.0.tar.gz"
  sha256 "9ccd8d530dad5d031230afd968cf54637b49842a13ececa6e17c2f67f6e9336e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b5aaccddf9b6c0c41800d2dbb9f8891a51b5e258e9c99f97ac65bd19ee2c4c9" => :mojave
    sha256 "1ca18e3fa85ad192c8bb96dd1b0d060fb9a2cbbdaf12875fe66196eab077aee5" => :high_sierra
    sha256 "bae549938d2954d8ffb3de7add885df8dbfcd020f65356fdc08cf2bd029c409e" => :sierra
  end

  depends_on "python"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/93/ea/d884a06f8c7f9b7afbc8138b762e80479fb17aedbbe2b06515a12de9378d/Jinja2-2.10.1.tar.gz"
    sha256 "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/jinja2 --version")
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
