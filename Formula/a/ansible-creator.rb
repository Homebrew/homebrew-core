class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/d9/e3/923f5c8d6a26a13b2d6a3b640db1923708bd439c5fc368677d61e056e5e2/ansible_creator-25.5.0.tar.gz"
  sha256 "cb050df5af0fa398a43464fcde8e761170e1cf12131c014dc4bc0c8f64f80632"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b162f69e2fdb6056d6f9652856803180c36b73c34cccea6c74fddb11a9e7fa37"
    sha256 cellar: :any,                 arm64_sonoma:  "4c4fa1d5441525f20d452d04ea36d9a2fb46ede0cd6ef4c26e50593f832c44a2"
    sha256 cellar: :any,                 arm64_ventura: "766f10319ac325ecf33edf60367525b0c01c476423768ce549662f401901eb6f"
    sha256 cellar: :any,                 sonoma:        "82cf5239ec5c21e7550ea0eae1a5159cf50b7964dd846311015000222a7d998d"
    sha256 cellar: :any,                 ventura:       "8e0e498ffe94323b50813f56759e1b9ccedfd23ed1138516e85167f82084cf3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d47fd35978dfae6170d866d2dec5f09f1d4ff093556a58e31ab10083ea2f600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5727121e30060f2629a27196e72505cff6a61910304bb8edf526c62f0d056a7a"
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
