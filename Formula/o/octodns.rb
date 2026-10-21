class Octodns < Formula
  include Language::Python::Virtualenv

  desc "Tools for managing DNS across multiple providers"
  homepage "https://github.com/octodns/octodns"
  url "https://files.pythonhosted.org/packages/d7/dc/7459cfb9f3bf85aa541b1b3283f0d9749e82be3d70b03129409b72b4f0e2/octodns-1.22.0.tar.gz"
  sha256 "b880ece209a19f33edc05ec13db55abee844e4a851978a19c48b4e3ef317bbf0"
  license "MIT"
  head "https://github.com/octodns/octodns.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0e0149174e989daba28ef155f86e6900db3a260fec5bb72dc0928b29a8fe49ed"
    sha256 cellar: :any, arm64_tahoe:       "deb426dc5ff850c1432d15a72578894680371462b1925aa00a1dbb18a2ea77c4"
    sha256 cellar: :any, arm64_sequoia:     "e3d2f7d1040cd2b8f38dce3da43fbadeb9ad06a760261bc511fe946f6d7a6295"
    sha256 cellar: :any, arm64_linux:       "6e375fe6bc5f66c2b5843a0a3b27d88196190ff07c4228e98f1e7d87adb4e3e7"
    sha256 cellar: :any, x86_64_linux:      "f38acc5f9cfa938a553887047edf78a19fd39fbf0745ae759d2dd17e6cc3bbf0"
  end

  depends_on "rust" => :build # for dnspython > uv_build > maturin
  depends_on "libyaml"
  depends_on "python@3.15"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/02/01/248d44fbda9e78fa1a7b5a475194bef4c4a3e285db286419f3bb42f2efdf/fqdn-1.6.0.tar.gz"
    sha256 "e39bf62e2a9481aa2cb780554fdfd944dd8ee5f230eb831684d539cbafed8de2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    %w[compare dump report sync validate versions].each do |cli|
      assert_match version.to_s, shell_output("#{bin}/octodns-#{cli} --version")
    end

    zones_directory = testpath/"zones"
    zones_directory.mkpath
    (testpath/"config.yml").write <<~YAML
      providers:
        config:
          class: octodns.provider.yaml.YamlProvider
          directory: #{zones_directory}
      zones:
        example.org.:
          sources:
            - config
    YAML

    (testpath/"zones/example.org.yml").write <<~YAML
      '':
        type: A
        value: 127.0.0.1
    YAML

    output = shell_output("#{bin}/octodns-validate --config-file #{testpath}/config.yml 2>&1", 1)
    assert_match "ProviderException: no YAMLs found for example.org", output

    (testpath/"invalid_config.yml").write <<~YAML
      '':
        type: INVALID_TYPE
        value: not-valid
    YAML

    output = shell_output("#{bin}/octodns-validate --config-file #{testpath}/invalid_config.yml 2>&1", 1)
    assert_match "KeyError", output
  end
end
