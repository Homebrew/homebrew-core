class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/5d/6e/cf538824a8ee831c761714f57803da7ba556e2bdfacd039ce8e5f27cbf98/breezy-3.3.4.tar.gz"
  sha256 "7c412f39fa3c616871fb1ba2a83fca36cb65b28e7f2b55c99c663ae2d90b2301"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "90330d2d1674f6f993f6c317ef00d2220d4348c78a979c210279d9455e05e32d"
    sha256 cellar: :any,                 arm64_ventura:  "c779f1942367e1f623e845f4507e60fa2670e5c51d789565abdca9467942d73c"
    sha256 cellar: :any,                 arm64_monterey: "a177a4f939500231e515851cb56f4b84415f1981e4ac428e12a28f3a5949c995"
    sha256 cellar: :any,                 sonoma:         "822a00973e0ccb307ce080f4c769ce4e99e7ef2edddcdb69d0ea3ce5e36804f7"
    sha256 cellar: :any,                 ventura:        "0a550ee727aeb7e49b8e121d27fdc8760db2a4758be921a379ef8e35e1032906"
    sha256 cellar: :any,                 monterey:       "33d05889f4fe0f0ed1f0c28ed48d875872f680a8311741b3aaea46d7f85c60d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27075f632fbe9d96477e142e0df72238f145072b604dc4cfbd99c6a4f21f2fa1"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "python@3.12"
  uses_from_macos "openssl"

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
    url "https://files.pythonhosted.org/packages/af/40/98be4a5641b0244be5881ff5e00057f8227ff183d8675a697bdfeae43b1a/merge3-0.0.14.tar.gz"
    sha256 "30406e99386f4a65280fb9c43e681890fa2a1d839cac2759d156c7cc16030159"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/57/9f/0973293d232696ae191cef7c4e8eb1ebbdb7728c48662ebf04c26fd576e4/patiencediff-0.2.14.tar.gz"
    sha256 "a604d5727f996f0fd9de4534b143d3e803ec4f1b18e40cd78e91ab48a289a95f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
