class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.21.tar.gz"
  sha256 "86b34450e167f96208a19260d5c981046690097815cdf4bb56b3c9f299c9f8b8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ed24cf6f30dc47b00894484a9b8c6014990f7d23f6f4d6d84e4f8e25d94f3de"
    sha256 cellar: :any,                 arm64_sequoia: "9e36f3fe869416207650c74e8f1dc705c9575bb72eb2d792947c130983234974"
    sha256 cellar: :any,                 arm64_sonoma:  "7b389a5d054c24ac99bf68e558c210d936d7efadb302626c39f4fe88a23d4572"
    sha256 cellar: :any,                 sonoma:        "945cdd21ceda287f74e3eebf2c854de01fe4c4d1b2b0d247a6746aa89ad43afe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c429c4a2265ce7b06ab10da8a6e6d650f2da6eb7218020f169b680f7531d2ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8acd9f2d53717c4203133b9135555cf81c6ee984ab3fb65da7bbf8d30401f166"
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
    url "https://files.pythonhosted.org/packages/ee/df/4178b6465e118e6e74fd78774b451953dd53c09fdec18f2c4b3319dd0485/dulwich-1.0.0.tar.gz"
    sha256 "3d07104735525f22bfec35514ac611cf328c89b7acb059316a4f6e583c8f09bc"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/44/1b/45c4c070fcffb440a9ab721f9659c235896e6aef19e1774829eebbd5e94b/fastbencode-0.3.9.tar.gz"
    sha256 "ded887be2e7eb4bc4dc27742ff5ef2242e13dc169348dc2c91cc5055aa2f8285"
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
