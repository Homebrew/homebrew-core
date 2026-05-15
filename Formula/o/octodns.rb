class Octodns < Formula
  include Language::Python::Virtualenv

  desc "Tools for managing DNS across multiple providers"
  homepage "https://github.com/octodns/octodns"
  url "https://files.pythonhosted.org/packages/6e/54/ae4ca569227e34102c2ac80bdcf795052cce20dd9407fd66c1b4ed7e07f5/octodns-1.17.0.tar.gz"
  sha256 "76087921c14cab2a31dfb6da3ee3a1a8d741f509a409656fe198afa05095d7d1"
  license "MIT"
  head "https://github.com/octodns/octodns.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccab52d471bc7fb2602a691608ae0d19a7b259a65d61f41dfa90825bc42c2988"
    sha256 cellar: :any,                 arm64_sequoia: "17dccfda6ebf10bcd2a8c0cca3aa173e52152a13c1f8d28454942cc4885d87bd"
    sha256 cellar: :any,                 arm64_sonoma:  "ad01e802b38f4117c5dd3ff67793ef0022072bb2e80d7dfebb5359e75bd0f0e2"
    sha256 cellar: :any,                 sonoma:        "330b895361d8ed355c3b91522fd379b6ee7254a229faa46ebe15d7e400014e5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c21bad624544e7131c42970f7ef8b23d91c471a3cb69b4beb4abc8cd69d42bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9d52cd9fdaad360f22d450c75cf4f8d9bfd11a306e2bccd536e0ee358c0ac9"
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
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
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
