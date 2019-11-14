class Mdbm < Formula
  desc "Y! MDBM a very fast memory-mapped key/value store"
  homepage "https://github.com/yahoo/mdbm/"
  url "https://github.com/yahoo/mdbm/archive/v4.13.0.tar.gz"
  sha256 "99cec32e02639048f96abf4475eb3f97fc669541560cd030992bab155f0cb7f8"

  depends_on "coreutils"
  depends_on "cppunit"
  depends_on "make"
  depends_on "openssl"
  depends_on "readline"

  def install
    ENV.delete "CC"
    ENV.delete "CXX"
    system "make", "-j8"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ts_mdbm = "/tmp/test.mdbm"
    system "mdbm_create", ts_mdbm
    assert_predicate ts_mdbm, :exist?
    system "mdbm_check", ts_mdbm
    system "mdbm_trunc", "-y", ts_mdbm
    system "mdbm_sync", ts_mdbm
  end
end
