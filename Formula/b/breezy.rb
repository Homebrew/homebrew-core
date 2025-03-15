class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/15/b1/4d7fe9b01f072bd18bf4c6c4bf546b9f18ad4c3890f3f11fbb4d20f5bdbf/breezy-3.3.10.tar.gz"
  sha256 "8e61aeb4800048d6f8fe43f701e510b571255387e64a999624caf46227b58cf7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "632597502c8193a468b86edc1e926415e17945a044c55bc6eef0785cdafa025e"
    sha256 cellar: :any,                 arm64_sonoma:  "32162b4e48bed6abd9223423de11fd10f3e512cb8076aa4b6d60788db4d4c0c4"
    sha256 cellar: :any,                 arm64_ventura: "a7922bc0194274a0699ebaf107d4124b0ba660da338d178bff2c0ae4db7c7d53"
    sha256 cellar: :any,                 sonoma:        "05fe3857ce2ab38a93f2697405bbbeced3d528c0f34a98cc3eedcda458e18d74"
    sha256 cellar: :any,                 ventura:       "09cd865c9142a653f13c9eca3c7a070537a8d4af4fa9c3384067f75cd7ad1e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2e0d12ce6916e0db46a858a6a91d3f9a676ca7f5d078f2305fd83ffde43368"
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
