class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/93/03/0a6f18ad63ead456f26c1105c1994373044b1c13b1cb2d69c50b8625cae8/ansible_creator-25.3.0.tar.gz"
  sha256 "bfa12d1191a2bebb1b51c1dc68066b9c10705702716b0d634dd1ed03af393344"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4b6aebbf1e921fea814e908203041858b0533531f540f4255a27c38a69db1f1"
    sha256 cellar: :any,                 arm64_sonoma:  "f738621174c11bebc727c6f7ed97cc014764fff35be78ddd0dab562fbfb95e61"
    sha256 cellar: :any,                 arm64_ventura: "b66c122a2409f76b9151fb82dcce2b866de33bc80b3de618a9e25dae877f058d"
    sha256 cellar: :any,                 sonoma:        "3a60f49e12b035c7d6c43b313aed87884b31a5d00cd45f44a6d5011397b6eade"
    sha256 cellar: :any,                 ventura:       "4e3ba2f6e685ea48df35b0592285eaae148805b4ac456f2ebc263915e7949e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bcd33f5dd2390452a5d13dc4f8f566866a5c7e63b762df1125900fbde0baa7e"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
