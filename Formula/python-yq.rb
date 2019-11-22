class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://yq.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/5f/50/06196fef59e4f09f8ad3490c0ccca8c1d1b020fabc122cbde8290ce2f7c4/yq-2.9.2.tar.gz"
  sha256 "9a169c2cbdabf2e3151e7e289ac9aa94ee4284c135eacb630703102d6e321edd"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cf55e4db9df972150bf6b5fa25366cc77b6efe8eeeef0c80be138d7301fd6eb" => :catalina
    sha256 "8cf55e4db9df972150bf6b5fa25366cc77b6efe8eeeef0c80be138d7301fd6eb" => :mojave
    sha256 "8cf55e4db9df972150bf6b5fa25366cc77b6efe8eeeef0c80be138d7301fd6eb" => :high_sierra
  end

  depends_on "jq"
  depends_on "python"

  conflicts_with "yq", :because => "both install `yq` executables"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
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
      :PATH       => "#{Formula["jq"].opt_bin}:$PATH",
      :PYTHONPATH => ENV["PYTHONPATH"],
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
