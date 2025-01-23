class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/52/bc/32cbe5da6d0216d70f83e3f751b16b5cfe1500362fa07e12d1819afe2bc2/ansible_creator-25.0.0.tar.gz"
  sha256 "f3348e185ae9ec2fb522c4b4cb4eaa4eb67e7f53f767acbdfd6739f22421b8e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85e88791ad7a129725e44441edaabaece13c20a214c9ea5c428e8203c4e1479b"
    sha256 cellar: :any,                 arm64_sonoma:  "8bc60eff09fe1a4537c731a3096044a6a3489b2ce63c6f380f311ae4aba43753"
    sha256 cellar: :any,                 arm64_ventura: "9a8fa22dfbc053f033b1cd05827b26fb9d856d6dbbcec17fcf5c3ebb7d49e61a"
    sha256 cellar: :any,                 sonoma:        "1d1fcab7fa731bf1dd64633572025b9d24ffd89ec56d33d9382663f15837e76d"
    sha256 cellar: :any,                 ventura:       "80a7911d795852f0f0189a2ea1e9dc4bc8c3048f9e3a4ee6d2ec84028f144b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20350be282372d53371735f975868fe35c2d0776faf2caf5438ab91c313d66b2"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
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
    assert_predicate testpath/"example/galaxy.yml", :exist?

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end
