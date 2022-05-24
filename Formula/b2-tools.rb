class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/8a/f2/d2ab885c30c17344d40bf0f6ad13ba12dc05aec5db358662c68981b9fb27/b2-3.4.0.tar.gz"
  sha256 "c7602998cf81e760c42481914d48f5ab8a38f3d4576bbb91dfee39576549c9e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f729f1cea8328e042d32b081ab87f742e9c5cfd71ec7da2a6da5a61683a5f4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29270f350cbc9a472e25b664c4d44cf6b50263de3cb7937ed71fb9953645a0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "2275ca4d3449d3f7174dbbc3737316a370082ef1a840adaa8185a2a370d4d2a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "76ebff46da1f84a6ac2669da67aba19b574b57b57fee45b5b929c2b50ffe23b0"
    sha256 cellar: :any_skip_relocation, catalina:       "2d621b34337d797cac01e1216fe108e87d4510eb7c96c44c02a6a39e2144926c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "394249af04c99ff7b967e5ea8f6c778f20d5f1fbb6a7711655105ee94f17073c"
  end

  depends_on "python@3.10"
  depends_on "six"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/48/28/30a5748af715b0ab9c2b81cf08bd9e261e47a6261e247553afb7f6421b24/arrow-1.2.2.tar.gz"
    sha256 "05caf1fd3d9a11a1135b2b6f09887421153b94558e5ef4d090b567b47173ac2b"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/3d/be/61b8631fc00c4036136cb0b31359f0aa25da1e35b64676b79e7d0637372b/b2sdk-1.16.0.tar.gz"
    sha256 "cbffff1163bb8e7cc920c76b29f5e889369d7f5ef1b7b53c89fd5bb79f5ea9c5"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/ea/48/b1acdd934f89377fd047401f02c301b938f4962f5af30b8ad7224487c412/phx-class-registry-3.0.5.tar.gz"
    sha256 "f11462ac410a8cda38c2b6a83b51a2390c7d9528baef591cb5b551b11aba2a92"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
