class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/f6/7d/72547d62b755884eec83efa86cb59890ac544e321b4854335af472fdd0b2/ansible_creator-24.6.0.tar.gz"
  sha256 "dd5633623c2fd53f20e2d77a0b8b3616b48b3474df91ce4d17a40bf763906079"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1fe8041cd00cd0dc4a585f3d1c24bf6a98d2d57809c895a27acb0a0f193774c"
    sha256 cellar: :any,                 arm64_ventura:  "7046783781d912581322db58d0cd141a73a213ff382782e1e5d6943e534c536d"
    sha256 cellar: :any,                 arm64_monterey: "973543a8c85799d6bb8f6ae7325a319fe4c8a4484a9a88cdb5cc125265081df8"
    sha256 cellar: :any,                 sonoma:         "80a6efc96d724645029af067dfff7fc8f91469fcf9aafdb2f7fe6d2ea078cf8f"
    sha256 cellar: :any,                 ventura:        "476665a0701a626c2938c93483f355ab4d6142c3a2efad6243bc1dd7b470a324"
    sha256 cellar: :any,                 monterey:       "99abe05b7cb29de27caa25007110fa66a3b5cec77c14a6806874ee079e1c96bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c83d4623c00c1bd2d827101a9c79e6332ed621f4c2b6ac062f8eccc44ca179f0"
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
    system bin/"ansible-creator", "init", "exampleNamespace.exampleName",
      "--init-path", testpath/"example"
    assert_predicate testpath/"example/galaxy.yml", :exist?
  end
end
