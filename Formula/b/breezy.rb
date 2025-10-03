class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.13.tar.gz"
  sha256 "1a8b1e53263f181e0a6d433aa9dbdd21cf34098d2c9db5b177ef7250f5d0754a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d141e0f7da711dc02ed34af7f5a6d57535cfbf878ffb43dd3a5c71b3d9c35af1"
    sha256 cellar: :any,                 arm64_sequoia: "f2fa0a5745fd475f7fa14bb46aaefeaf11912f0193c09381f1016d731b65eb9f"
    sha256 cellar: :any,                 arm64_sonoma:  "e32406ac7594a81b0e29fa1d9210171501bce68744dd31454dd9e82f15b01324"
    sha256 cellar: :any,                 arm64_ventura: "768905b6c14d037c7c0f5f39f00b1140e7bba62a9a39a781f5a9a4ffe9784ebe"
    sha256 cellar: :any,                 sonoma:        "1b3687ada3c0af81d2c87f9d4808aed45d93e0777348db549545e2762461265f"
    sha256 cellar: :any,                 ventura:       "0a252d93a527bc5b06f37bc7c922ab4e5362aa77780d9d44961b02430d4c779c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "231e15f3d4d6a5b03c6a44e5e6856082f5e9950eb3663dc8afba7a166ebead74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b09e7fb18087a2a4659f23a2b3470dbdd83fa9d6148d6c2028016151e92589f"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2b/f3/13a3425ddf04bd31f1caf3f4fa8de2352700c454cb0536ce3f4dbdc57a81/dulwich-0.24.1.tar.gz"
    sha256 "e19fd864f10f02bb834bb86167d92dcca1c228451b04458761fc13dabd447758"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/78/e2/e6a8f5598c1d1e1181776678691dc66f2cd74a745ef175ac15ac9d9c148c/fastbencode-0.3.5.tar.gz"
    sha256 "2445663753bb41ffba1c43e9e94e7c1145d1dd6f7c8f62a97f0585063ee449c3"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
    whoami = "Homebrew <homebrew@example.com>"
    system bin/"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system bin/"brz", "init-repo", "sample"
    system bin/"brz", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin/"brz", "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end
  end
end
