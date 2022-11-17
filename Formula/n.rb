class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.0.1.tar.gz"
  sha256 "ad305e8ee9111aa5b08e6dbde23f01109401ad2d25deecacd880b3f9ea45702b"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a713440029965885a313b22d7fba78b30b2e56003a2b2955f8dfc01029e8836a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a713440029965885a313b22d7fba78b30b2e56003a2b2955f8dfc01029e8836a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a713440029965885a313b22d7fba78b30b2e56003a2b2955f8dfc01029e8836a"
    sha256 cellar: :any_skip_relocation, ventura:        "ba3883ee8187e4990fba2df1315831f211e579ecd83f680f582c9f33af541a34"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3883ee8187e4990fba2df1315831f211e579ecd83f680f582c9f33af541a34"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba3883ee8187e4990fba2df1315831f211e579ecd83f680f582c9f33af541a34"
    sha256 cellar: :any_skip_relocation, catalina:       "ba3883ee8187e4990fba2df1315831f211e579ecd83f680f582c9f33af541a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a713440029965885a313b22d7fba78b30b2e56003a2b2955f8dfc01029e8836a"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
