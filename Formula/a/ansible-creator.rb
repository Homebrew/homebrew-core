class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/7e/51/0092ba38b3dda96dcf626d5df9b8238c92332dc36605d40820a7f66ae9c4/ansible_creator-26.11.1.tar.gz"
  sha256 "99eebe6dba30539eb76549d2bdcaee692dd0b2b48e6f942abc5728ce2ec9f4e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "42c0a19b2713fc9fb7d08bcfabf9c3938d28c63067db9af04c8890a7b97baf29"
    sha256 cellar: :any, arm64_tahoe:       "b02725af2eca7e7a12eea6d5b0e37f183026c4c7b44283f80cac6a2038439728"
    sha256 cellar: :any, arm64_sequoia:     "4b93423e04c709c2a7b9f140f365eec987b4a86e3331aac9f5cfab3655fade1b"
    sha256 cellar: :any, arm64_linux:       "c73d1ff0b33937a7a31b6defa8dc277454292e57638fbaf1ef5013bcc086a264"
    sha256 cellar: :any, x86_64_linux:      "8c9dd9edfb791dcc2fbf49798fd5c03831c6cf8d6a267976af03335a760f1a29"
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
