class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https://pocsuite.org/"
  url "https://files.pythonhosted.org/packages/12/33/a9f77b222075f034c04c615de19c9ef0f93457d9b627e95cc40d07949e70/pocsuite3-2.1.0.tar.gz"
  sha256 "4107396b5fbbeeb65b27b574c6fb5a40831d1983ad4fd2f9a83c87006bed98e6"
  license "GPL-2.0-only"
  revision 8
  head "https://github.com/knownsec/pocsuite3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9dcf1785263f08cfc32aecec76a42804eb4ece4b6971a22e2b155f18dafb960c"
    sha256 cellar: :any,                 arm64_sequoia: "a0c27c3f071b0c05faf67057961038b83c1940f458487ea52320f8af0e9064f2"
    sha256 cellar: :any,                 arm64_sonoma:  "4554a5dda53de31256c21de971d6e1e1244de9460b3a4b6802c70eaf5d9096e4"
    sha256 cellar: :any,                 sonoma:        "c8b7ae5442c00c35427bd51f87aaf6e2885fb096161bec0fd05c569198dd4ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fdfccc07c0c3a4f3c8f789278fc4ec1bfaf4dbe118f27664eb8ac7a54d60698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94fd59fd5d363d0268e6218e43d297bf6241b05dbbacfc8bee4df0823dd4b004"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:     "pocsuite3[complete]",
                exclude_packages: %w[certifi cryptography]

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/91/d7/47988d40231b41376f5a66346ef3b322c81091dfd4c0f84df5a1e3bb06b5/chardet-7.4.0.post1-py3-none-any.whl"
    sha256 "57a62ef50f69bc2fb3a3ea1ffffec6d10f3d2112d3b05d6e3cb15c2c9b55f6cc"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a2/61/f083b5ac52e505dfc1c624eafbf8c7589a0d7f32daa398d2e7590efa5fda/colorlog-6.10.1.tar.gz"
    sha256 "eb4ae5cb65fe7fec7773c2306061a8e63e02efc2c72eba9d27b0fa23c94f1321"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/55/a0/7ca79796e799a3e782045d29bf052b5cde7439a2bbb17f15ff44f7aacc63/dacite-1.9.2.tar.gz"
    sha256 "6ccc3b299727c7aa17582f0021f6ae14d5de47c7227932c47fec4cdfefd26f09"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/fa/e5/b16bf568a2f20fe7423282db4a4059dbcadef70e9029c1c106836f8edd84/faker-40.11.1.tar.gz"
    sha256 "61965046e79e8cfde4337d243eac04c0d31481a7c010033141103b43f603100c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jq" do
    url "https://files.pythonhosted.org/packages/b8/ef/60ec5e3d8b6ae79c02af010030692e9e7e12a3a8134bc048728de16eb137/jq-1.11.0.tar.gz"
    sha256 "67f1032e3a61b4e5dcdd4e390527b0000db521ac9872b64517c83c5f71ef8450"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/91/1a/edb23803a168f070ded7a3014c6d706f63b90c84ccc024f89d794a3b7a6d/mmh3-5.2.1.tar.gz"
    sha256 "bbea5b775f0ac84945191fb83f845a6fd9a21a03ea7f2e187defac7e401616ad"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/8e/11/a62e1d33b373da2b2c2cd9eb508147871c80f12b1cacde3c5d314922afdd/pyopenssl-26.0.0.tar.gz"
    sha256 "f293934e52936f2e3413b89c6ce36df66a0b34ae1ea3a053b8c5020ff2f513fc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/82/97/7caec64f05eae3d305d83e7cce1ef2f337710513b89efb334f7278202e79/scapy-2.7.0.tar.gz"
    sha256 "bfc1ef1b93280aea1ddee53be7f74232aa28ac3d891244d41ee85200d24aa446"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}/pocsuite -k ecshop --options")
  end
end
