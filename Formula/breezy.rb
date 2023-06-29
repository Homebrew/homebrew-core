class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/f8/31/0777685b4093d5a8e42aa181da6450cc37ee4eb9e8a84900adcaff35515a/breezy-3.3.3.tar.gz"
  sha256 "5ab5e6c69eb7ba36b995f3c83e33e7be1d5dfcac2b9283888e1e0c61e47030e7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8d7d685fa6c2a0596ffc08cb1bc11331fd33289bdd837b0e263609b07ab2db6"
    sha256 cellar: :any,                 arm64_monterey: "82600d48c2d72d29c5dc5026d8c770692c0650ae7db8e6ec0612383291696be1"
    sha256 cellar: :any,                 arm64_big_sur:  "f382ee6ccccb7c0214751db08f8b25e178cafc7b465d2560b935159b3351d44f"
    sha256 cellar: :any,                 ventura:        "c0b537b7162c22eac22ae8ea5053981341721515cab1481033eb4d88f1cba17d"
    sha256 cellar: :any,                 monterey:       "edc6f671bc590c9c205aad8baf9aa92de42f4746fb9e677855a8b453a498804e"
    sha256 cellar: :any,                 big_sur:        "3247bf62663f56711bf959b3cb484309ccd57e663f5d3cf604e54b86cd52be3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9250d4d6f9abe6c6637ccb64255b9b09e99ccf390461490faf925fa7a732136a"
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
    url "https://files.pythonhosted.org/packages/8c/6c/57adedfc2e1debb62581e9b413d2be78ea62e1da47d21fdd9d0d10317ebc/dulwich-0.21.5.tar.gz"
    sha256 "70955e4e249ddda6e34a4636b90f74e931e558f993b17c52570fa6144b993103"
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
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
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
