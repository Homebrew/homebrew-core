class AnsibleCmdb < Formula
  include Language::Python::Virtualenv

  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/archive/refs/tags/1.31.tar.gz"
  sha256 "8de9a02e3f0740967537850f6263756dca1bf506cd95c1f2ef7f4ee6d9ff23b8"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1273a6462f8b5745a2b1c297020a609de08c88703908deea3d3276a9af8e5a51"
    sha256 cellar: :any,                 arm64_sonoma:  "1fe8dcbaadd7a83a63b6d2e9e7c33baf6eebcc7e6653f9a57ba7837759858a0c"
    sha256 cellar: :any,                 arm64_ventura: "6f14fe8987e3919f7352c24eb57c59129a453047c0e759a1e265289c52f74092"
    sha256 cellar: :any,                 sonoma:        "ebccc3b4a0ce69d9ac06c7dd8fcb922b0513031e6531010b4e80e01b3a94d942"
    sha256 cellar: :any,                 ventura:       "3e171c3d264163e93fe3ad96ce5113d49f560d8c596f1dd6460c8a950b626240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166c728e271581dadf1c2764ab910b85b44ebffe41c3822b5748311184242beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a142934b4b440e622a1e6958818e4588103c5a4511ac97fff5cb639a75323444"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

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
