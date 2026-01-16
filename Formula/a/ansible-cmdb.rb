class AnsibleCmdb < Formula
  include Language::Python::Virtualenv

  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/archive/refs/tags/1.31.tar.gz"
  sha256 "8de9a02e3f0740967537850f6263756dca1bf506cd95c1f2ef7f4ee6d9ff23b8"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b6be47954b66a7ecc04bfff866f4417a531171c2bfa3dcf1ac7c17ed5bac7e5c"
    sha256 cellar: :any,                 arm64_sequoia: "2164c629351884de60aaa7fa684d2384ee24e81c23f5515064becc5728cb7597"
    sha256 cellar: :any,                 arm64_sonoma:  "f169a1b45de20cb12c7b2c8399fbc32e5d565a808d4a11b919d9595e02ef7175"
    sha256 cellar: :any,                 sonoma:        "5a4011e6d5933f8e6fa6f6933fd0a222d15ad535bcdf4f4849a89ca5b8200fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e02eca8dd4bf47a7cb861cd1c6ee75f735a46696b1e7e665cd1eb5f2e8f9cda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c82c4713092df1c5856967eb0d0d4072622d531083501e3995dfa27f10f2fbdb"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "jsonxs" do
    url "https://files.pythonhosted.org/packages/65/62/67257a84338fde1b89fce8b28164364bf2ad6a5a4459a6a890cf497cf721/jsonxs-0.6.tar.gz"
    sha256 "dc41ae07961f3f19f97241e4c7f611d84d076c420dd2876aadfd936e59c8c302"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/62/4f/ddb1965901bc388958db9f0c991255b2c469349a741ae8c9cd8a562d70a6/mako-1.3.9.tar.gz"
    sha256 "b5d65ff3462870feec922dbccf38f6efb44e5714d7b593a656be86663d8600ac"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "ushlex" do
    url "https://files.pythonhosted.org/packages/48/e0/33fa11058c8efc51ba3520ceb85c9fa0c5e42ce414b885fcd5e12132d13b/ushlex-0.99.1.tar.gz"
    sha256 "6d681561545a9781430d5254eab9a648bade78c82ffd127d56c9228ae8887d46"
  end

  # from https://github.com/fboender/ansible-cmdb/pull/260
  # fixes imp being deprecated in python 3.12 https://github.com/fboender/ansible-cmdb/issues/259
  patch do
    url "https://github.com/fboender/ansible-cmdb/commit/02242d4eed9d4295d02cf2835a51eb4f422b18cf.patch?full_index=1"
    sha256 "5b63452cd28eb49afa2ea927e61280e864bf04edeaf830f37f5e63620169fd41"
  end

  def install
    man1.install "contrib/ansible-cmdb.man.1" => "ansible-cmdb.1"

    inreplace "src/ansiblecmdb/data/VERSION", "MASTER", version.to_s
    virtualenv_install_with_resources

    # built binary needs python and ansible-cmdb.py paths
    libexec_python = libexec/"bin/python"
    inreplace libexec/"bin/ansible-cmdb" do |s|
      s.gsub! "which -a python", "echo \"#{libexec_python}\""
      s.gsub! "BIN_DIR=$(dirname \"$0\")", "BIN_DIR=#{libexec}/bin"
    end
  end

  test do
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
