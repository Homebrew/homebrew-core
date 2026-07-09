class Octodns < Formula
  include Language::Python::Virtualenv

  desc "Tools for managing DNS across multiple providers"
  homepage "https://github.com/octodns/octodns"
  url "https://files.pythonhosted.org/packages/6c/3f/efa3684728098eec6e406958920497704805e9d676a32cb75f2fa9abb439/octodns-1.20.0.tar.gz"
  sha256 "35a556be684e8e07a02efb7f8c26669cbf16cb6a74c302d59410569cffb3a1e2"
  license "MIT"
  head "https://github.com/octodns/octodns.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05d38df4419b25199d2a31eb3367c78c4e47b011fa798e14f374bf228e784b4b"
    sha256 cellar: :any, arm64_sequoia: "3d8d28646e796699d743c038bd3bfe70ce33cf861578d6b8d225e39e5638507e"
    sha256 cellar: :any, arm64_sonoma:  "72a9e7c115c572cbf910bd31c05b465316cac0520637e28f8c60494333442b28"
    sha256 cellar: :any, sonoma:        "4036ce816f8fe6327230c786169919a189ddd7aaebbd5df0782b5ef2ee18fec4"
    sha256 cellar: :any, arm64_linux:   "c2d003b4bacd88d0fb1c35760ca11aa7178f552acdf22831abb5c535cc8a3790"
    sha256 cellar: :any, x86_64_linux:  "65403e85d1b7e4b5b216b3135c0bb427e916fb50ea1b17fb7407e014ca8a4ecc"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
