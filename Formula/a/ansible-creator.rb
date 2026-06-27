class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/81/72/466f53d93fd26a16c8020b5c53e1594757491ce75be58abffa48790a5266/ansible_creator-26.6.0.tar.gz"
  sha256 "411cbadc595c18945e2c5e4f4bbdab82c6c2db524dbc816b22fb47157252622e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d733b6a1382b8a55dedb3f2b9199b0e538801f2e2aa191efe6f047f6c39ce834"
    sha256 cellar: :any, arm64_sequoia: "c57a376800b5563d487d30ddbb1f29c0dc42f5b590aa1e2d90bd7176bdd744f6"
    sha256 cellar: :any, arm64_sonoma:  "a2b1f5c47017d602d03c124e96751caef194e607c2ed985361d40c564b1121b6"
    sha256 cellar: :any, sonoma:        "eb898f0f9903ab0e2919c00289614270cffccb1b775a98a161f92814e92dafab"
    sha256 cellar: :any, arm64_linux:   "9a448b82e8123df8b96b051689c0d9d090f35865961bbcdf9487e241b1bc16cc"
    sha256 cellar: :any, x86_64_linux:  "ad13f917f788abc7b02b0e17a079c5c02f661f37de489191a8548eb422e280c9"
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
