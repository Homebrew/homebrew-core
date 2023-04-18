class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c11a97038a56d1aa36a7ed69d1f0db3db2432a395ab03cd91582d3e076df6bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d2a9ed0de47070ccccb9bb4855974983d760d44a18d558b8de1aa0de1762aab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a2551b5a1a5afa8a8d4f0e933812b2bb4caa833b4adcc844e40a79ce5c092cc"
    sha256 cellar: :any_skip_relocation, ventura:        "285d9c5049f9941155940151ff51f2aac42ad1bac97f4146b6fb04d593a98241"
    sha256 cellar: :any_skip_relocation, monterey:       "769229644b3cc74fe54c790e11605aa6413197fd250733f2773c5a91a3c419b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba3b4a73c83bb9ef943297f6233ec13800f149ec0896192cf7fce67a7c7324ff"
    sha256 cellar: :any_skip_relocation, catalina:       "7ba9c9266a0b3a8ce669c38f6da29cef8093b9cef67316e54833dc4210673c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f87debbf600f344cee4b71916a0c0674e5a9027dc1f7f8a864ed50e7c5bb9e"
  end

  depends_on "python@3.11"
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
