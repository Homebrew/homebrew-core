class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/07/3e/16ee36193be535dbd95e16bd0a668de58367fb0ff3a7759e47e7b954cb78/ansible-lint-6.14.6.tar.gz"
  sha256 "2a364458ae46c8edc3d6b5a78ac573dc1a49eec64c856c85a2cb205ea3d38a2e"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5d2ff410e7d6c186c8d005d1f9c74f7a878d6bbe36cf9145117b21e61d75339"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d3c88e01924422b1fc513524ebf3625675246893adb22d716f882809af76bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c517c97d1c84f30d6f8f219edc2493ebd052fd2609ca909dcd3c454adbced160"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea5d1d85ed528c2a276e15dccd91f22de881238fd27f24e1983f9ea86405429"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ffed538ebcc5cf8b0ee097cd1913a7d776744219f23cccfd28f30228450450"
    sha256 cellar: :any_skip_relocation, big_sur:        "eafb684e0ade364158f2900bff53c6be8b16e269e3abe958613735381c7246ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f126ae23ab981a253e3c5ffa4a20ec9ec922e790aa05f2aa8cae35a712dbfd"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "black"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/3d/c80975c1028f54e4f0fe6f727d9271362b749321144ea833216b18bfda93/filelock-3.11.0.tar.gz"
    sha256 "3618c0da67adcc0506b015fd11ef7faf1b493f0b40d87728e19986b536890c37"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/31/3b/2360352760b436f822258396e66ffb6d42585518a9cde2f93f142e64c5eb/rich-13.3.4.tar.gz"
    sha256 "b5d573e13605423ec80bdd0cd5f8541f7844a0e71a13f74cf454ccb2f490708b"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/f6/a0/acafd85c7c0aead293a16a70a49aba20ba2af9478771370b2897eae6059c/subprocess-tee-0.4.1.tar.gz"
    sha256 "b3c124993f8b88d1eb1c2fde0bc2069787eac720ba88771cba17e8c93324825d"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    %w[ansible black yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - name: Homebrew test
        hosts: all
        gather_facts: false
        tasks:
          - name: Ping
            ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
