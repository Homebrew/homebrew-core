class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/e4/31/8b72e0d4588dac3b0c09fb31844bddf51c512be445f733fa55c640c46fa5/breezy-3.3.25.tar.gz"
  sha256 "01932bc4f7e4c15f6b57b208224e78490d3f4af777869aaeb877a965637c8095"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/breezy-team/breezy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5019b82bc91a7086f27e67f1ce5fdc4d5c6c9b75b0c379180b641219296d900d"
    sha256 cellar: :any, arm64_tahoe:       "d9b2d5d6e28bddab37a363fb8578dd3f73cadb684f8828408142f8fa6e8d347e"
    sha256 cellar: :any, arm64_sequoia:     "f76d6fd562d1d1c663b645aafafc6a62bb73b8d680fc970089539ba4f8273c64"
    sha256 cellar: :any, arm64_linux:       "00109f3d97bc901d304111cfc6aee34a3dff5eedad6b5eb8b56a2f5122233005"
    sha256 cellar: :any, x86_64_linux:      "eed3019539fed6524a80dbaf32c5d6cd30490542e5ae0d5684326a7565ddcf34"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.15"

  resource "catalogus" do
    url "https://files.pythonhosted.org/packages/e9/70/d88303967b16fd7f937a281fe9899ea5c34602296d8a6a07bb188acaf218/catalogus-0.1.2.tar.gz"
    sha256 "0737aced12078b67e9ef5c0cd5fda0a8c14fd6007a83c1e4c1930a2245e2bd9a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/01/d1/01adf1db003374db4c2a70f7bae757ddfc39a33d9fb5ab765522b4d339e6/dulwich-1.2.21.tar.gz"
    sha256 "5d3939f64883e6799614cab708ef4ee9ef415dd6dcad47527cdbb0eea43bf3a2"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/ac/be/21ea2218a70d634a32cd1c8be2c11624cfcfeaeec14016f04187a394f6b1/fastbencode-0.3.12.tar.gz"
    sha256 "a0d403f3122aae24d34d2682665e505925bba7a6d3246da482b7a2a9cdcea8fe"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/41/f7/5c8c25a763bf630cc26a466c86bb336ee2ed607e459c6d12dac20a6d3aad/merge3-1.0.0.tar.gz"
    sha256 "4a8251068cdb2c1aba76d31ae6aff5e6a47c79a1ee1071d5a58f37bf09f2a790"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/bd/ca/7d530d7bf5e3094f86a67b9698045ccb86fc122f2ed024472ee9f6dc55c6/patiencediff-1.0.2.tar.gz"
    sha256 "bfeca9984ba88fd36745b64e1271a52b407a2919ecdd6aee850d0374a16e3457"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "vcsgraph" do
    url "https://files.pythonhosted.org/packages/ee/03/5cdc1f74eff7a8532c1f28a789dddfa0984f5f392c08d67e96608c557639/vcsgraph-0.3.3.tar.gz"
    sha256 "db2100058c50784c3d24984920ceefe61b951e915cb483ffafa116fdfc18cea2"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end

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
