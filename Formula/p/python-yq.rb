class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/fd/be/ae37199d28a0a99eb79084f91da94f6e7e58550552361a2397c5032d5d37/yq-4.4.5.tar.gz"
  sha256 "e17b21a927d04ae33f61a7284351b69b0a539bfb73b852a04a907b79bcd15de2"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4780fc41aadaa1c5dd4da39884e55cc310a5bd32f308421a0f0ca5e074a37b7e"
    sha256 cellar: :any, arm64_tahoe:       "3756af0595a98639e30508e07c8ce6032fee1312bba81d7161272748e5037095"
    sha256 cellar: :any, arm64_sequoia:     "016af85998d6ba273239f7d3a45fcbc875c817d9501fb513c3e9d5467d98fbf7"
    sha256 cellar: :any, arm64_linux:       "9918f3a1888289c7df776afeab9184b48a24755de32ef294c8cbfbd56e1002e0"
    sha256 cellar: :any, x86_64_linux:      "a2d1a5f75e3c7aa91609b066e397b439ff88807e7858c0a6d53eaac7fe9c0c32"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

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
