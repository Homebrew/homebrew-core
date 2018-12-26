class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https://git.zx2c4.com/cgit/"
  url "https://git.zx2c4.com/cgit/snapshot/cgit-1.2.1.tar.xz"
  sha256 "3c547c146340fb16d4134326e7524bfb28ffa681284f1e3914bde1c27a9182bf"

  bottle do
    sha256 "fd47d6d609f90119f930c5b63efcba5c47efc6be390459576751d558f82f3d32" => :mojave
    sha256 "99191e176752e4f4d2069ed941c0efdd0927463b011ebc1c6f0cd9d6cac26331" => :high_sierra
    sha256 "f60bf2a6028c022202ae9df8053a89e67be606a07a7ce630b89dbeddb2c6022d" => :sierra
  end

  depends_on "gettext"
  depends_on "openssl"

  # git version is mandated by cgit: see GIT_VER variable in Makefile
  # https://git.zx2c4.com/cgit/tree/Makefile?h=v1.2#n17
  resource "git" do
    url "https://www.kernel.org/pub/software/scm/git/git-2.18.0.tar.gz"
    sha256 "94faf2c0b02a7920b0b46f4961d8e9cad08e81418614102898a55f980fa3e7e4"
  end

  def install
    resource("git").stage(buildpath/"git")
    system "make", "prefix=#{prefix}",
                   "CGIT_SCRIPT_PATH=#{pkgshare}",
                   "CGIT_DATA_PATH=#{var}/www/htdocs/cgit",
                   "CGIT_CONFIG=#{etc}/cgitrc",
                   "CACHE_ROOT=#{var}/cache/cgit",
                   "install"
  end

  test do
    (testpath/"cgitrc").write <<~EOS
      repo.url=test
      repo.path=#{testpath}
      repo.desc=the master foo repository
      repo.owner=fooman@example.com
    EOS

    ENV["CGIT_CONFIG"] = testpath/"cgitrc"
    # no "Status" line means 200
    assert_no_match /Status: .+/, shell_output("#{pkgshare}/cgit.cgi")
  end
end
