class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e1/b6/00502cc0db06ccec929e1b94e418e73ed7c8056e0bda2d0b71206b14ed94/yq-2.11.0.tar.gz"
  sha256 "8654d8217d98caa4b03bc00a7041b3716e7e6f441516b52a3f7cc91578c1e9be"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "01134f6bc2acd0c2cc57c572e8d17e31f16ec258f442a87c43a86a2e40839bc7" => :catalina
    sha256 "01134f6bc2acd0c2cc57c572e8d17e31f16ec258f442a87c43a86a2e40839bc7" => :mojave
    sha256 "01134f6bc2acd0c2cc57c572e8d17e31f16ec258f442a87c43a86a2e40839bc7" => :high_sierra
  end

  depends_on "jq"
  depends_on "python@3.8"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/df/a0/3544d453e6b80792452d71fdf45aac532daf1c2b2d7fc6cb712e1c3daf11/argcomplete-1.12.0.tar.gz"
    sha256 "2fbe5ed09fd2c1d727d4199feca96569a5b50d44c71b16da9c742201f7cc295c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
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
