class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.81/pev-0.81.tar.gz"
  sha256 "4192691c57eec760e752d3d9eca2a1322bfe8003cfc210e5a6b52fca94d5172b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/merces/pev.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "7de65d5c0b950da40c9c315f774b464a1aaf5d1a3402a4da2b8bdce395e54437"
    sha256 arm64_big_sur:  "934d51d93b71115060a0a61bd458867760bdd429e31bf7b8ec58ab4958ab85f4"
    sha256 monterey:       "7ca58d8adfb22028531bc5ddb4fe849de267253040e637d3b489602db94429c8"
    sha256 big_sur:        "3b08293af4c00d399504754c4e6971287c1e16197547e8ae25cc44bae908c71d"
    sha256 catalina:       "621dfa53cab827d0788c4b0f0df3f0ed46fef15ac6b5a6211fc30aa8e11a5c3e"
    sha256 x86_64_linux:   "e795e98f80a0ff2683f4405257890e93f43290052ffe5945241375899812f8bc"
  end

  deprecate! date: "2022-02-28", because: :repo_archived

  depends_on "openssl@1.1"

  # Remove -flat_namespace.
  patch do
    url "https://github.com/merces/pev/commit/8169e6e9bbc4817ac1033578c2e383dc7f419106.patch?full_index=1"
    sha256 "015035b34e5bed108b969ecccd690019eaa2f837c0880fa589584cb2f7ede7c0"
  end

  # Make builds reproducible.
  patch do
    url "https://github.com/merces/pev/commit/cbcd9663ba9a5f903d26788cf6e86329fd513220.patch?full_index=1"
    sha256 "8f047c8db01d3a5ef5905ce05d8624ff7353e0fab5b6b00aa877ea6a3baaadcc"
  end

  def install
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
