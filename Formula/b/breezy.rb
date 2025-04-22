class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  url "https://files.pythonhosted.org/packages/d6/47/165a8967701fb047b46879db7d2fa50b80fd3e7da22fb54ba131b823081c/breezy-3.3.11.tar.gz"
  sha256 "11cb9c5e2fac2038630e863088f047eade4653cbf2b995f732322f6c143bbb3b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18de1e46e39cc1fffd09957e8ad4e0540888ae0dced13ed845215e48df3be1d5"
    sha256 cellar: :any,                 arm64_sonoma:  "90af0ddd36f5145ec511a2a7f08ffd0b401ac803239b68ccda6b077971c7e328"
    sha256 cellar: :any,                 arm64_ventura: "91a651789c915c683c12e12de61c32acb1c3e717ab3c30b76cabad8ed3736c1e"
    sha256 cellar: :any,                 sonoma:        "afd4d74f45956b3a17cd28d50ebb2d64dbbc88d0ef7ff71ef7f1235fc9bc45e1"
    sha256 cellar: :any,                 ventura:       "f293746961a03e4daba8041edf6a69228b029f29289ab065e4cca1761e3b170b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62669cf5622f684b2602b79687f4cd8b87581ea2f3dbb596609f669f1a0a7457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87623611f90764d2b2d56f9aab33335efa3987776e606bf02c81f7315ea54bdb"
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
    url "https://files.pythonhosted.org/packages/d4/8b/0f2de00c0c0d5881dc39be147ec2918725fb3628deeeb1f27d1c6cf6d9f4/dulwich-0.22.8.tar.gz"
    sha256 "701547310415de300269331abe29cb5717aa1ea377af826bf513d0adfb1c209b"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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
