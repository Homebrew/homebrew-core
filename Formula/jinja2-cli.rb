class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/b4/d8/db91896b7bc075d93da3658095948dd6ff62e692c7acef463e41ef47e274/jinja2-cli-0.8.0.tar.gz"
  sha256 "9098a9f554bbfc91153547cbaafd48254698bed94e6d57d906d8286a3c8620c7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e7e9f7d2a1b88f8f5d2d7484edeb62234a51d045b578df6963b044298e58615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11a23f02be9916f831a4e8639e9c581a1a22495086e36dbc9155d1e02c08ef66"
    sha256 cellar: :any_skip_relocation, monterey:       "2391d625b1078379209b67009c9a0d2b93e8159a99eaba018c1e04422c568a0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fbc8bb7f975a94812101fd094963fd43605e463ca6e18ac524cb292eda60863"
    sha256 cellar: :any_skip_relocation, catalina:       "9c776168317a1180b6a8f517bba3821f98fb5ff23fda662f1398b98cbab5df2f"
    sha256 cellar: :any_skip_relocation, mojave:         "5cbea09cdfdc17b06ecd92cb8e209fc1a97996b7a3db2624d86c80da889f6c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0cc1ad20dc99d07c505ce4a99039f13946bfe0c804e732c0768dbd1482cd9e"
  end

  depends_on "python@3.10"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
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
