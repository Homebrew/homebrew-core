class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/29/43/b6d5e389fb41f689459fd0d148c6f4f7e7bc3c30f1d8ec9e3386415973e8/ansible_creator-26.4.3.tar.gz"
  sha256 "db8a33fa765f5a3cb4f17ac6856a2e9e93b2434a7ecf5cbbdd495d96b0ec71d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27fe01ad3071ef63436825c0740688e6a7096930889ac89791652b72ca6d4bbe"
    sha256 cellar: :any,                 arm64_sequoia: "cca13bed50f7b6a587273c4a3ba19f2e03502375cae07ff2ebf98bad5a12dcd4"
    sha256 cellar: :any,                 arm64_sonoma:  "31a37437fac1a014d6b97eb47cf24bfb35dd8272ff617ce1b8ef4d18284915a2"
    sha256 cellar: :any,                 sonoma:        "11962a0e6e5d6749d356b52c6ca1526df301ee436b5bace99080a803ea3dcfd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eb26b48f7cd02a6f9faf9b5ce7d4e18eea406d1884a3d6e91febcfaadea3d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "319779c6d1dca218828a49adef95a06de4d1a229b5d3e7333ec49047f33926f1"
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
