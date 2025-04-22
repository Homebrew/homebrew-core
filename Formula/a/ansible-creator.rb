class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/78/1e/7d963cacf1778101cd0e309be302dea6742cdaab62ec5d4312c996502f5f/ansible_creator-25.4.0.tar.gz"
  sha256 "8295451e9334d220ffccb1226849d750b886e5a182f5bdc7bd1f1e4a0d768d58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "590744d4d9997bc99832f9cf411c45cb00dbf845eb4be628678df34f0a882328"
    sha256 cellar: :any,                 arm64_sonoma:  "5a2d4e504f9b8bd5c77a532e1fd7fa7bb6877d7385ab179b5db933e5590eb2b9"
    sha256 cellar: :any,                 arm64_ventura: "7b5a5d02b0b25886bc6382efd67f5ebfb29e4cb155e2e8b24e12a60f5d661dfd"
    sha256 cellar: :any,                 sonoma:        "49796c833f288095d61e5504c3b309f56b6eb99c95a266731100610e228f8887"
    sha256 cellar: :any,                 ventura:       "fdfb1f55caa5ce95399d4377bcb836e244bb1292e053690a04c918ea04a01964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ede134f349c6c4f961a84f299db398e82f175d0b80b7f1f893fb6e075a162671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0502890e8bdc1e01a06fd792876b10edae543719f1453f177218e11c262ef515"
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
