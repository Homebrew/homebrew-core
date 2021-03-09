class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/29/54/d7adf40d30cd56fd5b0f0a6f9af0171f98157f0a318b696f9fcb4e842f51/yq-2.12.0.tar.gz"
  sha256 "1d2ad403504d306b5258b86c698f9856d7ad58b7bb17a2b875691a6a7b8c4c20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3d413c423a4369a7d722ca9b97d9b0dd07ec0952c0662af027abafe2f6d2869"
    sha256 cellar: :any_skip_relocation, big_sur:       "77a3b59a07dcd9856282bc7c863672227be02a1b7d84cde9bd7d2577c1cb1b2c"
    sha256 cellar: :any_skip_relocation, catalina:      "ad8ad7411f3d147443ec64697b696e63dce6286c26288676de64a105a1845af9"
    sha256 cellar: :any_skip_relocation, mojave:        "97f1278c54c24044b19496a8ea1dd0cdd37ebed7fffd9e9824635b096854e4a2"
  end

  depends_on "jq"
  depends_on "python@3.9"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/cb/53/d2e3d11726367351b00c8f078a96dacb7f57aef2aca0d3b6c437afc56b55/argcomplete-1.12.2.tar.gz"
    sha256 "de0e1282330940d52ea92a80fea2e4b9e0da1932aaa570f84d268939d1897b04"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
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
