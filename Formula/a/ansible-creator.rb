class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/26/1d/413ab25deb3559ba6644664c4f2d2a75992bf39ac90706a38a0a64e5ced9/ansible_creator-25.4.1.tar.gz"
  sha256 "eaf957414e278c85dcd622544011b20aec61f689c94d574c2358e4115b1b92e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb6b030e1d839a64a473552f59ec9074c4261477c3e59f38af462b3db7515a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "9577e1f0a89cd77e1105c260337f71d84945d43d0ef939a126fd4efcac492526"
    sha256 cellar: :any,                 arm64_ventura: "14093f0949a3eb22ace5e4b79ef23655a3bcac0daa251d7d0262a3e79bb8bf79"
    sha256 cellar: :any,                 sonoma:        "f92bc2b07383ed8c947abad4fffbd36187ee8738f29d0c0acb5ee189bc16c052"
    sha256 cellar: :any,                 ventura:       "7251a8e425b5418f5131ad3dad76c7741a7a275729783b47dc96c03148aa3a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2ca0538203293e85c13aa4ebbb4b5573227520ab649534027035ff672bc9a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ede365818875d4ed853fa7d9177c156101c4828d70028ea280fd6705d9141c"
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
