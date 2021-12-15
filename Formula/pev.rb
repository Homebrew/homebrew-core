class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.81/pev-0.81.tar.gz"
  sha256 "4192691c57eec760e752d3d9eca2a1322bfe8003cfc210e5a6b52fca94d5172b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/merces/pev.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "9a6e1d64960daa44838f688dc596cb7ca02536521c7c39ee5349021870f41172"
    sha256 big_sur:       "bd9160da3191fbdc8c251c6513ae6ca73a330575171e7742e2488f655999d864"
    sha256 catalina:      "d1effa68a21b99e2ed18ad0b0ceb5b4732ec253a818d4d88204801b02bba43ed"
    sha256 mojave:        "0ff3ab7fe514f498dd088d42fd60e63bbd5c7fb3d94222aac68c5a4302404f2f"
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
