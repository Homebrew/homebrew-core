class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e1/5f/212c5a30bb31e9c96bb89455b7c58213ef22f1a24e2497b743ef8092004d/yq-4.2.0.tar.gz"
  sha256 "53854078bade13fd69eef85d77dcc513125a0bce2f8f1ef8b466e655ce1be9e6"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "abf41f6822db6cef80a2dfe3ad349d35ac8be3a2c0f7f9732fa6d64993b204e9"
    sha256 cellar: :any, arm64_tahoe:       "99c9ad7f28498cad641bcbc6f056d24de9228db93081c69aa17356eaef1f87d9"
    sha256 cellar: :any, arm64_sequoia:     "447e71beeb9789096d46571b0de8782070f38686c4034390670ee5d6779b4d6d"
    sha256 cellar: :any, arm64_linux:       "a6c97017413c394c44e6c3efd144e9dbbbab9370f780929dfb5b47d39c44c36c"
    sha256 cellar: :any, x86_64_linux:      "18413d0cd6d600d7dc4df39ce1d7cd288e17f1b55b2d7fa749d0152836c94a73"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "jq", since: :sequoia

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
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
