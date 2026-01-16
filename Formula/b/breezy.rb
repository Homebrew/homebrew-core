class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.20.tar.gz"
  sha256 "32d26d0af0716e3580d7d97dda56ae441ab173f192092bcf762f590162f6bdae"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3c30ff77141a8a01f29a6bdbd615016194080cacf844d02013513e5616d7e42"
    sha256 cellar: :any,                 arm64_sequoia: "816e853e88e034890aafabe7bf0298a55f98aab3399bf92a52c986095bc4473c"
    sha256 cellar: :any,                 arm64_sonoma:  "c57392f95df45b15bd0ec726b9dcf0e20b1585ec72a5a3a80d5b038b3d46626b"
    sha256 cellar: :any,                 sonoma:        "86b69a66dcca06ce1f24a144a076a34eacec4c60a39a5d137f8e79a3534ec7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a42faf7abfd9118a18f1183a6f62398222d59cade50806252b370251207324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e67c96b8e12be8de4f9539348742089975ca5776c8018f9428f53d38f9ee924"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
