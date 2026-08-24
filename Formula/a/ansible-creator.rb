class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/97/3d/e4083537f694a2e5b529d52fc1535455bc8b19126a934dd3351100e5a2b2/ansible_creator-26.8.0.tar.gz"
  sha256 "f902fdd5e476eb471b886cf88b9d3d88ad7de25c2ebceea87001d0c92d4a23de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "22df5b679c2a8ff591fbe60bb1657c96711246a114610e6c4e61ae766ce63ec7"
    sha256 cellar: :any, arm64_sequoia: "8514864bfd0bd006ba63237b4619bb57fa4018504c7d151bd3b769c73e2954e4"
    sha256 cellar: :any, arm64_sonoma:  "721e3c54b9f4866d4890d5ca57c78647b13c158c8fab833f5eee28a12c4e53e9"
    sha256 cellar: :any, sonoma:        "85b50c34875b9676f752a7272ce36e2a909807f0e57266d00fcd5e66c82feddd"
    sha256 cellar: :any, arm64_linux:   "72c7776b69c2bb988ecac356fe087fa2ef7266cb49fbd6e7f13a745d88b240d6"
    sha256 cellar: :any, x86_64_linux:  "8190988c62d0ced7d2aa4d06704a467ea9967ed984e301e1ce1377253a408b03"
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
