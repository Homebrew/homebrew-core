class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/5d/6e/cf538824a8ee831c761714f57803da7ba556e2bdfacd039ce8e5f27cbf98/breezy-3.3.4.tar.gz"
  sha256 "7c412f39fa3c616871fb1ba2a83fca36cb65b28e7f2b55c99c663ae2d90b2301"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c16ebb435bfb13ecdbd387d0cbad06c68c1d52e2a2f3979b5cadd0d6a186534"
    sha256 cellar: :any,                 arm64_monterey: "ec239319c1488a8de5059dbaf1f5558bc8a0df6f74b1fb5142cf10159e5e0008"
    sha256 cellar: :any,                 arm64_big_sur:  "0be58a2d62beeb5069d0bae721408d5b7e141db0739ea64a281918588eb7bd01"
    sha256 cellar: :any,                 ventura:        "72f9c1fe8aec34dfbe33710570244ce167b23e6fc44a212d73a3e191458eba6f"
    sha256 cellar: :any,                 monterey:       "c59f159ba005d99c3e8dd98ccc211387bdf84e7a7d390b6eb4c09a2e824cdffa"
    sha256 cellar: :any,                 big_sur:        "c0f61ac752a36e933fc8e98c647c8fd8cf46d48cdba4e267ba81616e31fb88d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9c59819d0fa034007f44f2486607ebe1339a5e64e1757d9bfb55e1bcc3cf4c"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  uses_from_macos "openssl"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/57/e0/1b5f95c2651284a5d4fdfb2cc5ecad57fb694084cce59d9d4acb7ac30ecf/dulwich-0.21.6.tar.gz"
    sha256 "30fbe87e8b51f3813c131e2841c86d007434d160bd16db586b40d47f31dd05b0"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/20/ab/33ca3005953d689f1be9c1e0662f5359b7365479f7a8fbd66cb05e9a840d/fastbencode-0.2.tar.gz"
    sha256 "578eb9c4700d6705d71fbc8d7d57bca2cd987eca2cec1d9e77b9e0702db1e56f"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/dc/91/647a2942b6f308c7dce358bec770fe62ee0689cfd1dd218b66e244acde7d/merge3-0.0.13.tar.gz"
    sha256 "8abda1d2d49776323d23d09bfdd80d943a57d43d28d6152ffd2c87956a9b6b54"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/bf/15/313ca3a72a2c23844002b20171e5c8c0688c1bb640752eb1d35bbe62eda0/patiencediff-0.2.13.tar.gz"
    sha256 "01d642d876186a8f0dd08e77ef1da1940ce49df295477e0713bdc66368e9d8d1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
