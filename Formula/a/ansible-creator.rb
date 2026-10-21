class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/2e/34/de2be164fd02e7b7e0cfa33bbb4d0565dd40c5196762b9bbb305ab852bdd/ansible_creator-26.10.0.tar.gz"
  sha256 "99468d5fca539e65423e1acd6fe6ba8a67b1fb51473fae21b352c945ad068c1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "86bec49461ae1cdfea898ef14dfcd87bb64bab36ca0940caebf7686eca5bf7d5"
    sha256 cellar: :any, arm64_tahoe:       "983c36a5953da268a1c613fa051280a2fcba48b9d5b71a5529ab998d955e9e21"
    sha256 cellar: :any, arm64_sequoia:     "b9c3986437f5d65c6c66d05d984a79470fb99a2923cc3d6144514ef5148711bd"
    sha256 cellar: :any, arm64_linux:       "888eb5a215d29c27a8fbce96862cd1b789f1e1a37dd247f3d60ebbb642588f68"
    sha256 cellar: :any, x86_64_linux:      "2d168f3e76dc811c2aa59c311660f57d8f6d470798e5a23ce92de1508652b53f"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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
