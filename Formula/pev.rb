class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.81/pev-0.81.tar.gz"
  sha256 "4192691c57eec760e752d3d9eca2a1322bfe8003cfc210e5a6b52fca94d5172b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/merces/pev.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f88c38cd11c261d607ee24dffd8507996947261d798b05576d89e012fc63cc02"
    sha256 arm64_monterey: "42e5c0a125b5fcf2053d617d1d3d7de7d654c16542641b27dbf9a204c6654f8e"
    sha256 arm64_big_sur:  "92683bbe4257e80a1e303ba7752b2483f26d9ca8dcd418500c8867b841010e2c"
    sha256 ventura:        "2922947509cd028ba0d8c3a780825f4d2892117f1f7e123be7117230320074df"
    sha256 monterey:       "d3b2c9704022bd9027c6b83c7584060afee39c303e22f4778a520268c9d7764d"
    sha256 big_sur:        "aebcd75f9fa0c70f6318759347f1f6fa9fd36daa57bfed0b0d5caebb4b0d73aa"
    sha256 catalina:       "509f575210d62910d65c1e7d3a0eee7c12647aa9bfee465c6c71983314b08cde"
    sha256 x86_64_linux:   "0bb7e6192930c868b08379aadd687ce5f28f46d576748cda2bc4e6247849a522"
  end

  deprecate! date: "2022-02-28", because: :repo_archived

  depends_on "openssl@3"

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
