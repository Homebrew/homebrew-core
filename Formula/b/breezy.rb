class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.20.tar.gz"
  sha256 "8e4af88a0f55d1994c9f5f704db467e9967f8bf0e170440bc4077a972276114c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca212f8ccd074ee517804ba397c5246817386531b4e6177aaff4c5d2f5acbb86"
    sha256 cellar: :any,                 arm64_sequoia: "1d500ba45017525b0cebead6bd88160df8d76eab707b5c6cc1c255114c5d1585"
    sha256 cellar: :any,                 arm64_sonoma:  "0264869428361bc45c5b0dade6578d6b63d5a6d596a74d98abbafdfae6219231"
    sha256 cellar: :any,                 sonoma:        "c80977b799c8d664eee605c2f2688d07e2d6bc81e82ea75948a23aad5ebca78f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "488159b71a7f01667b0af73bb3540baa30ac740f50399a84886a3a21e6598584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5a7dc51ab106e04ef976af7c0ada1660b507cdee7e6259360a2f1ec4ea9260"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/6f/97/f65ab4c7d999bb10c717cace283bfe60dcaa02993ba445574e217ae7c71e/dulwich-0.25.0.tar.gz"
    sha256 "baa84b539fea0e6a925a9159c3e0a1d08cceeea5260732b84200e077444a4b0e"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/0e/15/2e1521cdc326919afa9dceec17e318abe325cab893512fd571c58819835b/fastbencode-0.3.7.tar.gz"
    sha256 "e96fd955d6d5980a913730ecbf838ca2863a6420f0d7c8d189087caa83393f21"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/12/71/daaa7978561b9a7bfdcee4ba5ec2ead6162f6a9d2e2edf069def96085c6b/merge3-0.0.16.tar.gz"
    sha256 "0852de4381cb46be5ef4ed49e3ac20c5a4a0cd46a8ff4bbb870bc27aab543306"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/29/42/795991d063200c34094686bd3659a228caa1f4aca1afa98593d06a3d9344/patiencediff-0.2.18.tar.gz"
    sha256 "a678d8252bfb060f1f280fd32d47d917d323e93e1a94ff4ddaaba693a6f66aad"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
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
