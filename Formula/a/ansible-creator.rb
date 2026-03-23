class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/49/d1/7f4d40461ad3de061ad3eb0732322de5b0e88f2b4f4972cf9ac17a5c8efc/ansible_creator-26.3.2.tar.gz"
  sha256 "411a368b740e66b36e58ea4f1eebf0ef5c53eb56dca8a9bd1411613be50ff2a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee8b6c1139fe0fc99fe1bde13b57e1bb061d5644dadc5a9d095e66f726dd6ad4"
    sha256 cellar: :any,                 arm64_sequoia: "c492d94d976455fe219a8336948ba9502159faf0ec7f9addf036ec6c91d0c232"
    sha256 cellar: :any,                 arm64_sonoma:  "4a308b1c2abc34bf61f53443f7033e83fe1b1ebba93932e52d7c3aa25fff546a"
    sha256 cellar: :any,                 sonoma:        "36e42f0f662509600b7d06da68957da05fe3a1d805460e356e6c3ddbd08e02bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908eaebd3120264a5a9f98a971f2cec45219d9b92a680ab8ab58a8fe3a45fd4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e596536300c4f7d427962933ee4c23e7e4f76c7d1a559c8f01dce1cb708afa"
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
