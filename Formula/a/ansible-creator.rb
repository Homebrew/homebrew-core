class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/c4/fe/32f2b1325ad520b9341186f79ca1170e8b45a70d3f1d28076d8bcf40136f/ansible_creator-25.12.0.tar.gz"
  sha256 "dedc26d4172e9e7ca339995932d69a4a0776ec5678ebd8eac576d5ddfa3b7259"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "825de900c604ba1cb6ff15416657aa00470fb940d385e66cc324f2e0413b1d4a"
    sha256 cellar: :any,                 arm64_sequoia: "828997099708c20b23b7f00241df8a508b3405241936fa7f25c5be4816ca23c5"
    sha256 cellar: :any,                 arm64_sonoma:  "9db9701e4395af2b576eff6907fec462c9d3aa7c2e31b2ac54ca8f98b637168c"
    sha256 cellar: :any,                 sonoma:        "b9324fbf4124ece5dea373bb57910605436e6bf846c34f06cc0ae2a9abac2d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aadb28b913682750c320eff51093962682353553d6a8b8a29d5ceab9dd1d8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f5fcf4d60021a70eeb3871322c045e4b1ee28cbd8c651994802d37a45eca84"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
