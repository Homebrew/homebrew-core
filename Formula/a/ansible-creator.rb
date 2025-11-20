class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/d5/c4/88b664f9973b9e15f4f4dfdf022f07d4d0ae676f2e9f320d141a5ef4c8ea/ansible_creator-25.11.0.tar.gz"
  sha256 "1ba0662f3480ba80c81b2c0dc08168b705f559e0881a4497a4e6338e51193e1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0835b7b437650e10b52783a59a1f13484eaa287557d90cd93c371ba548513dfe"
    sha256 cellar: :any,                 arm64_sequoia: "8b20466653d2936afad70a59bbe45af290082c74500abe679c7e7e59cc4508bd"
    sha256 cellar: :any,                 arm64_sonoma:  "e0d53fe7d062ebb6cdd4ce7b76c5f05943716c85f900957fa96d386deaeabbac"
    sha256 cellar: :any,                 sonoma:        "ca9c6d029e88c82c88245155a31123697a1cbdb3cf15ec506190c1f2d0454cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555344330fd45aab841128a2fcd1471936ba147d7c581339284ec11f9359cc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9205e6d4a0e8b090081a7a5f9a660ac41da29f5710e3b35e6e9cfe2929b637d3"
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
