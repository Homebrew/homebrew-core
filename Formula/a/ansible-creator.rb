class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/7e/51/0092ba38b3dda96dcf626d5df9b8238c92332dc36605d40820a7f66ae9c4/ansible_creator-26.11.1.tar.gz"
  sha256 "99eebe6dba30539eb76549d2bdcaee692dd0b2b48e6f942abc5728ce2ec9f4e5"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "ca391930f36a056a1ef0b046893d00665486471968776586ffa0c64db9b6b7ff"
    sha256 cellar: :any, arm64_golden_gate: "10332c2bed59f1293155f49bb0381f8d38276ff244bfd2c47093634187c8a9c6"
    sha256 cellar: :any, arm64_tahoe:       "331ad6911cf21f89525d401d0cd899c139f07898756a21fea24c40ae5606f2c6"
    sha256 cellar: :any, arm64_sequoia:     "b5cb227213a64b12367299d06efab3bda70cd0361c1b1e3f33d15e31701ccaff"
    sha256 cellar: :any, arm64_linux:       "ebccc527782d9515dd3f2512283d46efcf377a4c1251d7c8130bd91524301526"
    sha256 cellar: :any, x86_64_linux:      "4f51be46b1107ee2414c70b11e05ca0d7d2308965c95cb58f857b1a53ccfb95b"
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
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  allow_network_access! :build

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
