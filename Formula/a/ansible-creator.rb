class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/b2/b3/c4b4e4ae2cbf5969ad0ac2115891b2c6113ef017a24b98bf1c92b46eb418/ansible_creator-25.6.0.tar.gz"
  sha256 "86a93cb301def2064ffd47d9b0cb8d1e3ae8a46cf9ea108b27cfb288144cf5ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "322c456b9fcad7d01f43f1b7392916b103d0a5eb8a5a0893ac6ad31c1ee3fe86"
    sha256 cellar: :any,                 arm64_sonoma:  "0ed9eb41d6950e0fcc5c1250282259c1083779739ddcca038915152eccc20c51"
    sha256 cellar: :any,                 arm64_ventura: "ce7ecac79f79197ba43adae7fe7d4223ee9c1ee47a7650f60eeb4076520c3382"
    sha256 cellar: :any,                 sonoma:        "2b1d2e2d569a71bf7e4dfa98a8d27bd9ba079579c83029c9bf2088e2ed923034"
    sha256 cellar: :any,                 ventura:       "cd34e9860d1791951d56467c4ded8bfa6143a25c8ba1ef2deaa1f7332a7e0522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00693f850ce7b44bc3351429c4c40f55a11e780be33a3f30f6937727be8ba033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a1593041bdd37e1bf0f1037c425cc15ac9a791a99aa91b7930e61ddc14eb67"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "examplenamespace.examplename",
      "--init-path", testpath/"example"
    assert_path_exists testpath/"example/galaxy.yml"

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end
