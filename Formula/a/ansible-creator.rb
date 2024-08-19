class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/e4/4f/a290e46703917fe3684ee0d373a4b6162471c7b185e9885cca9248fffb74/ansible_creator-24.7.1.tar.gz"
  sha256 "7e4011a5feb54ada254b52bffd30f86c0ea4d309569da0175528c2efff48dd30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d0ae62028ff5c202be4f7c2d299ebe673c39ea07f23d9e32aebd57a87dc7bc7"
    sha256 cellar: :any,                 arm64_ventura:  "692eea81b2528678bb9a86a97b0d40a4e7b0b269ff4dbdeda0a1809eb72bff45"
    sha256 cellar: :any,                 arm64_monterey: "aa629720864b6b3023d4e4b95f1cc8f6c387f51cbc6f9a343beaf9143739432f"
    sha256 cellar: :any,                 sonoma:         "6e56c889dc5a232f91483c6f1b1d912b730f4190bcbe27d6602a4e4788ad8be8"
    sha256 cellar: :any,                 ventura:        "cddf0ddffa39940d37702406c504a11af55cbfde9d6871c6f45fb43916d5eb41"
    sha256 cellar: :any,                 monterey:       "ff09f94d7bd3ed9e97bed7243e5870e0f221348351a1e63f6087261ab0b26f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa78cf60af898e2977f8b004ffd6ea93f81143c4f12aae89b0ed0ab99c5784b"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "examplenamespace.examplename",
      "--init-path", testpath/"example"
    assert_predicate testpath/"example/galaxy.yml", :exist?

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end
