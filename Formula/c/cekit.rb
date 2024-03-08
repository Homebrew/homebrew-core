class Cekit < Formula
  include Language::Python::Virtualenv

  desc "Container Evolution Kit"
  homepage "https://cekit.io"
  url "https://files.pythonhosted.org/packages/2b/e8/f6f756156e26ee85221306123f60b2f1162a0d988a0e59f195d0631ed21f/cekit-4.11.0.tar.gz"
  sha256 "5dc7ce15f903c2de20b119a18086c042a28ed0c72ef7f1d5956fa20cef2cfc32"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "473ea6afdb211d88f5ef500d863eba46deee43ea76e3d34ee04ca51876ae5a2a"
    sha256 cellar: :any,                 arm64_ventura:  "f528f533601a6a0958a55d7b015f510cfc1493fa1afab94799249b4905e59f78"
    sha256 cellar: :any,                 arm64_monterey: "a19bbe1bcf354f6aaa52b2280cb76c6dd0a1798204910050a9919e6dabd1c719"
    sha256 cellar: :any,                 sonoma:         "042e65bb6c9034b0713998480d0d98e981dca158558693f5b9de26b40d30490c"
    sha256 cellar: :any,                 ventura:        "d45a491d8fb943bf1ca2b7761bac0ed9929802a62f266ffccb36385ee065c5e6"
    sha256 cellar: :any,                 monterey:       "53b69f7cd4e471adff3df3dcbc1f64ebbb5613934f35f683b26490350ea69259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a6fec4e02cc2f79ca541be59ad3797d5fd66494b5931390b66afbafab56d17"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cekit", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cekit --version")
    (testpath/"test.yml").write <<~EOS
      schema_version: 1
      from: "scratch"
      name: &name "test"
      version: &version "0.0.1"
      description: "Test Description"
    EOS
    assert_match "INFO  Finished!",
shell_output("#{bin}/cekit --descriptor #{testpath}/test.yml build --dry-run docker 2>&1")
    system "#{bin}/cekit", "--descriptor", "#{testpath}/test.yml", "build", "--dry-run", "docker"
    assert_predicate testpath/"target/image/Dockerfile", :exist?
    assert_match "FROM scratch", File.read(testpath/"target/image/Dockerfile")
  end
end
