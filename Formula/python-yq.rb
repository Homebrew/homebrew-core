class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/c7/3d/79eef9b78f2245a28446196c43d3744163b5e1783904f6bad2adb6cb4154/yq-2.10.0.tar.gz"
  sha256 "abaf2c0728f1c38dee852e976b0a6def5ab660d67430ee5af76b7a37072eba46"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1058d79ca6634fc9dc1a4bb852be87bf56e3636c4a4d6d52e0817c9f138188b" => :catalina
    sha256 "a1058d79ca6634fc9dc1a4bb852be87bf56e3636c4a4d6d52e0817c9f138188b" => :mojave
    sha256 "a1058d79ca6634fc9dc1a4bb852be87bf56e3636c4a4d6d52e0817c9f138188b" => :high_sierra
  end

  depends_on "jq"
  depends_on "python"

  conflicts_with "yq", :because => "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/84/44/ad7f3fc9483b776dcee11d0a1dcadb6e55c456e06ae611073b82bc8d63d2/argcomplete-1.11.0.tar.gz"
    sha256 "783d6a12c6c84a33653dc5bac4d6c0640ba64d1037c2662acd9dbe410c26056f"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cb/bb/7a935a48bf751af244090a7bd558769942cf13a7eba874b8b25538f3db01/importlib_metadata-1.3.0.tar.gz"
    sha256 "073a852570f92da5f744a3472af1b61e28e9f78ccf0c9117658dc32b15de7b45"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/4e/b2/e9e512cccde6c54bf66a8e5820a2af779eb8235028627002ca90d4f75bea/more-itertools-8.0.2.tar.gz"
    sha256 "b84b238cce0d9adad5ed87e745778d20a3f8487d0f0cb8b8a586816c7496458d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/8d/c9/e5be955a117a1ac548cdd31e37e8fd7b02ce987f9655f5c7563c656d5dcb/PyYAML-5.2.tar.gz"
    sha256 "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/57/dd/585d728479d97d25aeeb9aa470d36a4ad8d0ba5610f84e14770128ce6ff7/zipp-0.6.0.tar.gz"
    sha256 "3718b1cbcd963c7d4c5511a8240812904164b7f381b647143a89d3b98f9bcd8e"
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
