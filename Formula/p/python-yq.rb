class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/f1/9c/a0185c81994ff06e2e992f23a1378f0bbb0769496376b59af682b5f6fc8d/yq-4.1.1.tar.gz"
  sha256 "ab3fc344dc4a39d833d328f080a6e794c1cb7243b05c0076ac1edce3d22caabd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5fc7c7e5e15f94b2156422a806000bc3c49e08381c159fbce75571941abf382"
    sha256 cellar: :any, arm64_sequoia: "0823dcb74fc919bd5e2092f9e3064e4922f051c01188a723e8113d0192add7f8"
    sha256 cellar: :any, arm64_sonoma:  "4243a7b51affb306c86f4611853e502f257e475b72e9f223284ab519566cd7e3"
    sha256 cellar: :any, sonoma:        "362031561532defd252510ce7bcf196fe836c5178c9abd3c7bce522c6fb24205"
    sha256 cellar: :any, arm64_linux:   "97c0855f2666b722c3c9f980eff1f8a68401e28d39efb7afa4e27db2cb860fd3"
    sha256 cellar: :any, x86_64_linux:  "4c509e0159150825967526df06a56778eb7d122cabda7a937cebf2adb289bf18"
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
