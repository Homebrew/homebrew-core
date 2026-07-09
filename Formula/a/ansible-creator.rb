class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/9a/fa/0e0fd750cbb589abc4f1a89dd226e83a61e7d52c89b621c2894a0b8c2305/ansible_creator-26.6.1.tar.gz"
  sha256 "f43103907e24302f0090fdb6fa6f8d39c299ad4fc248dab1326526fa72a7f42b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c77da278c762252fc2a65357cfab1bd206a04bece9f56f772602c778d1ad08f5"
    sha256 cellar: :any, arm64_sequoia: "ed93072241f63454dee4cf249c51b245b63a35d4172b77f3f1e2b95a3bae33e2"
    sha256 cellar: :any, arm64_sonoma:  "ad62bb64f3edaf99a95993f562f398c5fd79bfb8c7157a1bc1db39084a357ddd"
    sha256 cellar: :any, sonoma:        "487b9b218a2492117b0c02b88b20a533dac3d61d35b3218a96b851d8d7b8ef1d"
    sha256 cellar: :any, arm64_linux:   "9ee4a54a6fe05922e6f8480ba05be7c0e59e992b043dd1cfa405dce9f2f36b2c"
    sha256 cellar: :any, x86_64_linux:  "4a13114cddbc049eb3a6afc96502fb4472b431753c6d126303609525825ce08a"
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
