class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/77/8f/b7e9da70e379a0250096b953fa40f504a99bddd641b373cd99f8e0417c3d/yq-2.13.0.tar.gz"
  sha256 "fd131fdb1f56716ad8d44cd9eaaf7d3b22d39ba8861ea64a409cc3f4ae263db8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01daaf8e43008c395ccf72223e825a93aa18a123dcb8d5d84209dbb8ecc87c92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01daaf8e43008c395ccf72223e825a93aa18a123dcb8d5d84209dbb8ecc87c92"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf9533ef71e83cc6736a1f20b108895616644a8e437a73fbe45f6fe0670e46e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cf9533ef71e83cc6736a1f20b108895616644a8e437a73fbe45f6fe0670e46e"
    sha256 cellar: :any_skip_relocation, catalina:       "9cf9533ef71e83cc6736a1f20b108895616644a8e437a73fbe45f6fe0670e46e"
    sha256 cellar: :any_skip_relocation, mojave:         "9cf9533ef71e83cc6736a1f20b108895616644a8e437a73fbe45f6fe0670e46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01daaf8e43008c395ccf72223e825a93aa18a123dcb8d5d84209dbb8ecc87c92"
  end

  depends_on "jq"
  depends_on "python@3.10"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    env = {
      PATH:       "#{Formula["jq"].opt_bin}:$PATH",
      PYTHONPATH: ENV["PYTHONPATH"],
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
