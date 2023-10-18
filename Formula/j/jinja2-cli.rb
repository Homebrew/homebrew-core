class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5877de559d3245ef9910f6219827a37049ad1e59ecbddd9616c9e7de2d8f21b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17a39c8258f1e9807c811cdfbfd66a99b2031dd721eeb7157151dff0fcf2ce15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85c60441455fd51ad3b791891eeb0ac1c68246e229c350fcbd124e2b98b45d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c02f5a4bd053bbbd2a7626b80c0d3a942ada2920fe6df794d23441ee0a51698"
    sha256 cellar: :any_skip_relocation, ventura:        "ab899377d4bae73f94266f3b143d13b661adcd1d7137ae87a5b0302f1b43b752"
    sha256 cellar: :any_skip_relocation, monterey:       "5d6e942d8b535ed4f50024212c7cb014b3ecac815f74bbee67c6496018a2c121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e6172326dff855bdc8c57b6d6cea2352e6ba8d728ae99fb1364fd2e77f5ef3"
  end

  depends_on "python-markupsafe"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
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
