class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/e2/f5/d069a5d57b2fca3e28327c22cc95f2b0b75fb1e47d96cfe7beef0e218304/ansible_creator-26.4.1.tar.gz"
  sha256 "be0d80ec40939e21d240f8ad804f2d2a439a762b2e223bf0e3f2f4bbb5c92254"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59e3ee0ed4b2eeaf577ad8ad94f0ef00ce87f4da361eff7f29cb395110bc9813"
    sha256 cellar: :any,                 arm64_sequoia: "471489a17e566c4032e965af61cc0004814b2a3ed43df0957fd37c841c52de73"
    sha256 cellar: :any,                 arm64_sonoma:  "0d4917b28893e2b595841c1b215810043d2b36a2ed170d8a8e7b861a08e0adc5"
    sha256 cellar: :any,                 sonoma:        "fef81b2b94cf1258a32ad838884761ea8a10620a8c7adc6d215d8e2a0db7fcd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00dcc11ba6d9e27591e03aff7cfd959c2c45149a05993704ab6483744118c92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b602b2748d46112d3e042f46872e7c2f7fca3da51f0607c329f3e27e8a39a65"
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
