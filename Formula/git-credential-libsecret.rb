class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.xz"
  sha256 "97ddf8ea58a2b9e0fbc2508e245028ca75911bd38d1551616b148c1aa5740ad9"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "43e700f96ad11a809f2ee34fa9712a677916c01eca1f06c05bbfd66df331c189"
    sha256 cellar: :any,                 arm64_big_sur:  "5e0e1f6536b9d43c8482494e94d14b9a32938ae3e19561e5ef46838c905539e1"
    sha256 cellar: :any,                 monterey:       "88c52388c877a8e7caa88481e7bbde6045efd5fb230c540e26114982a74ce327"
    sha256 cellar: :any,                 big_sur:        "81585d54d2b286532ef1b55a8530e3b36855ddb2f5c48e38e245b6aca99ddbea"
    sha256 cellar: :any,                 catalina:       "2ba2240e6a3eabbce5ea2801a4ad440535f1a0a15f2436e0315fae777fc7ff36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c7ab34023037442a2aa3b562c453bede2157e3ed159296c5bfac6f18e193c1d"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
