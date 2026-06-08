class Octodns < Formula
  include Language::Python::Virtualenv

  desc "Tools for managing DNS across multiple providers"
  homepage "https://github.com/octodns/octodns"
  url "https://files.pythonhosted.org/packages/1a/5e/cb46895eda5d929b6488fbab2bcf2658272d60976e033cd9d2832a0fffcd/octodns-1.18.0.tar.gz"
  sha256 "a00eaa454c9c33375f2b76a4b742158033fba8acd01587ef7317a0657c053c0d"
  license "MIT"
  head "https://github.com/octodns/octodns.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e615e3c8148d44f2d65c0456b8b35a0d124cfa6373b5497e96d4833bb5d605c0"
    sha256 cellar: :any,                 arm64_sequoia: "1a73784331ae9dc9db4e2ed4565e6390d47ac276b3128e5f6efb1cef283f2d49"
    sha256 cellar: :any,                 arm64_sonoma:  "24eb81c782dacf5340989279419ecf790e15c70ac5ef02fc27804c1a950c9b00"
    sha256 cellar: :any,                 sonoma:        "ab408fe49493d056dd17ced83f6e8bb89b23d84a302d9e0bca9775903a34a6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b8a64186fe0e6974272dc1ecad65da8bde9c58da7ae71f3976803ecf6f9e809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f776babf55db8ba0719e1490a0275b15c829d845d57abe735e21590b2d5242d"
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
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
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
