class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/58/24/1e43bea1cb58532658a6d5b51a5f1d45d21df50eb1d14d977eb6d3064dbb/yq-4.1.2.tar.gz"
  sha256 "a8f148930f8beb3170f451d67f29cbe0b3ac713cd2fc91ecf51d43b4879e6b4c"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9016d2edb8a0d702385cdda32ed29643e7a076f6473eb74abe81cff2cafbd6f"
    sha256 cellar: :any, arm64_sequoia: "7d68c10b735df0d92efb05581382386e7a2d9754fbcc0ba508846c55a0bb17a0"
    sha256 cellar: :any, arm64_sonoma:  "6da269e23799b52e2faa751cecc8855abfac606a93b19714671b19909b0eeeaa"
    sha256 cellar: :any, sonoma:        "502df9372e2f375a1a440bb50345440ba348cfa02b8e986dee4a91dcf9d9ad26"
    sha256 cellar: :any, arm64_linux:   "816c7466bf03f39a0cc7c269c3b64ac3f10c72bcdc6533cb8fdb7350aedf1c27"
    sha256 cellar: :any, x86_64_linux:  "cf2f01f310536e287a0b9dee791569b025a1b3fbe0bf839c1cac23ae2e56ea75"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "jq", since: :sequoia

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/51/db/03eaf4331631ef6b27d6e3c9b68c54dc6f0d63d87201fed600cc409307fd/tomlkit-0.15.0.tar.gz"
    sha256 "7d1a9ecba3086638211b13814ea79c90dd54dd11993564376f3aa92271f5c7a3"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           base_name: script, shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~YAML
      foo:
       bar: 1
       baz: {bat: 3}
    YAML
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
