class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/6a/83/08cd79e47452c0faf9325e19c9a1dd26fabfeaaa8733804165a066c19479/ansible-lint-6.8.7.tar.gz"
  sha256 "de3de4e57cd54e17c1ec3a0b4a21d4811838e77d67b56cbe8f91107f2a434432"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05438d53d93841ca33af2ffe2e657950198e0e95661d570dba4e86c774c1fcb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416462e4a75fc790818c754d780d26a53bfeca531bb67f4a6944e0565dcf1d0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dffaa80bab7fd80e89f625ba36da31543f8c0b069b768d9551cff336f637bac9"
    sha256 cellar: :any_skip_relocation, ventura:        "bfe42d71fe8e6f44920309eeb8280d6e47c44d63cc5ae4527b931b8655fc80db"
    sha256 cellar: :any_skip_relocation, monterey:       "7f22fddee85f27aa1c221b2a5a4e975dfa0d078b54b1a5a141675306a3b03916"
    sha256 cellar: :any_skip_relocation, big_sur:        "03bbaecc98bd893475f2957cf7be0bc6e6da61fb6db85600c8f1356e1b9f8afb"
    sha256 cellar: :any_skip_relocation, catalina:       "fa29fb22d062e8a5f6348480c56a8d88c1d99b8bb6be446c5c84e1117b30cf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7864b66619f7d74e3067519048a534a7459777464f0fcb0e0634a3334a238654"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "black"
  depends_on "jsonschema"
  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/37/1a/604884d3655a80476dff5ad3cc9991decc5fb26d3f5df51d38361c3cedb1/ansible-compat-2.2.5.tar.gz"
    sha256 "28c7c545fd60ef9c3059cfb2fefd27f92db091ff6b5868f83f121ceb5e1fe1b5"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/48/20/a38a078b58532bd44c4c189c85cc650268d1894a1dcc7080b6e7e9cfe7bb/subprocess-tee-0.3.5.tar.gz"
    sha256 "ff5cced589a4b8ac973276ca1ba21bb6e3de600cde11a69947ff51f696efd577"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.10")
    %w[ansible black jsonschema yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: false
        tasks:
        - name: ping
          ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
