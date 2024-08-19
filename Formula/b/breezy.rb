class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://github.com/breezy-team/breezy"
  url "https://files.pythonhosted.org/packages/bb/3f/f1b74d0e32c5455e53655bf095724d37e31b2f184b2dddb899cedbbb6c56/breezy-3.3.8.tar.gz"
  sha256 "14d59bbdf86b66c17327eb79a5883b4c70cc7794ed34f3e8a0adfce64edc58bf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edab49633772709291400f725343ba8cfe84aa826f27e91c31fbd0db0da5c6fe"
    sha256 cellar: :any,                 arm64_ventura:  "73f514eaba1a5cdb3484576c194333750bcb78dcd9a58b8369f193389a7f6313"
    sha256 cellar: :any,                 arm64_monterey: "ea1db54566f6c6d7382704537bfde477d022cd55aaee391cf92f41a58852855b"
    sha256 cellar: :any,                 sonoma:         "a7b1c719596410c2325aae139aa61cae610fbbc11051e16001e57a72e747a69f"
    sha256 cellar: :any,                 ventura:        "8255ce072473e845096bb43e378a34af9dc01a448ac62927e5120e5e9b91fa04"
    sha256 cellar: :any,                 monterey:       "a8ccd1ba70ac273ca529e37a920482ef03b108844fab168abf4782f38b4a39b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3535c3f987f6ed3e8824c74dd9efe6da885483db7a474890f15bde754d1c53a"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/cf/ac/cf6420b90832c4ffbc88b92962dd0167c58632c2b8d508d5baf4ecb0c61d/dulwich-0.22.1.tar.gz"
    sha256 "e36d85967cfbf25da1c7bc3d6921adc5baa976969d926aaf1582bd5fd7e94758"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/5c/15/98e1cbac7871d9b12823c5869d942715b022c9091ce19a3ff6eb29dbff2b/fastbencode-0.3.1.tar.gz"
    sha256 "5fe0cb7d1736891af61d2ade40ce948941d46e908b16f5383f55f127848da197"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/91/e1/fe09c161f80b5a8d8ede3270eadedac7e59a64ea1c313b97c386234480c1/merge3-0.0.15.tar.gz"
    sha256 "d3eac213d84d56dfc9e39552ac8246c7860a940964ebeed8a8be4422f6492baf"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/19/51/828577f3b7199fc098d6f440d9af41fbef27067ddd1b60892ad0f9a2d943/patiencediff-0.2.15.tar.gz"
    sha256 "d00911efd32e3bc886c222c3a650291440313ee94ac857031da6cc3be7935204"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/0d/9d/c587bea18a7e40099857015baee4cece7aca32cd404af953bdeb95ac8e47/setuptools-70.1.1.tar.gz"
    sha256 "937a48c7cdb7a21eb53cd7f9b59e525503aa8abaf3584c730dc5f7a5bec3a650"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
