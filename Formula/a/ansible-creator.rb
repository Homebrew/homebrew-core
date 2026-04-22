class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/b8/a0/d42ea02ef4f08969644362b7cd2f6586418a519dbcea131edc10330888a1/ansible_creator-26.4.2.tar.gz"
  sha256 "7b97caafbcf15ce630da0fffa7df954feecacba7a179176a887644887daa85ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efb7b84fe7e4385bec69cf2bf66d54bec0ce1f80325fcac081fa488313fb63fe"
    sha256 cellar: :any,                 arm64_sequoia: "da84313aaba2a235e98b80d178e4c4cbc46e8b8229f7e42a0d661fa08939c591"
    sha256 cellar: :any,                 arm64_sonoma:  "76fc77c4ea75b133e0e3f2cb9f972050156634f3848015c876e04aa79c2ecb1a"
    sha256 cellar: :any,                 sonoma:        "5d6ca656bd975babcf0a28ca04fe7b0bfaf76bca9ccc8955757e9f2e3127d919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5320553d6a01ede4fa9a77510d120023c73b46dde589bbcea0ee48774bf26643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c492f5acf5cb1cbcef0f2ae575040a69436a4514967df9d1d7af861d1a7eda"
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
