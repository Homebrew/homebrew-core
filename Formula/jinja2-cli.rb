class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2c27fed222d1b4d9fd23854b30559a8d0b5a520d8f08410f2b3be48758f21e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2959f96e55b3d8e3f9030db4ac9d6c8c5ba06e51a1411dd854dcd7765ee46619"
    sha256 cellar: :any_skip_relocation, monterey:       "8a68d03e07b8c6c0c6a70ec8bf40f70efd96aa0b0af1e51a1e3c860f9989a2f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5084fb300d9dbc82aa6a7438f8eafe65595d637b537e18851fbbd4d2b4ab2d11"
    sha256 cellar: :any_skip_relocation, catalina:       "5e58a0cd15e7e8e2fa144ee3ad83a4c9ecb702ba7ded94c463bb9ed59a22a42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e7d85123642611a753faffec7b98fb20ceec023aa550f0f27bc11bce1633749"
  end

  depends_on "python@3.10"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/1f/93/99a76d0fa1a8fc14442a6421abee323f8d15964979336eabd2a1834e9118/Jinja2-3.1.0.tar.gz"
    sha256 "a2f09a92f358b96b5f6ca6ecb4502669c4acb55d8733bbb2b2c9c4af5564c605"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      assert_match version.to_s, shell_output("script -q /dev/null #{bin}/jinja2 --version")
    end
    on_linux do
      assert_match version.to_s, shell_output("script -q /dev/null -e -c \"#{bin}/jinja2 --version\"")
    end
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
