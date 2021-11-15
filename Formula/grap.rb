class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "https://www.lunabase.org/~faber/Vault/software/grap/"
  url "https://www.lunabase.org/~faber/Vault/software/grap/grap-1.46.tar.gz"
  sha256 "7a8ecefdecfee96699913f2a412da68703911fa640bac3b964a413131f848bb4"

  livecheck do
    url :homepage
    regex(/href=.*?grap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e1978deb80eeb33de6b6aef7be24a3dcf5f2710238ba2a8c86ff1eb577c58406"
    sha256 arm64_big_sur:  "b881e8e5a9e9b93597d99ad6fc3ffa06e277855fa2b49ccb697c53d463ae597b"
    sha256 monterey:       "ec648b01a035f781aa3ab6c027ee8095d85b6d49376f564cefe16fad11574fc3"
    sha256 big_sur:        "a36a748595465d9a1a85db3613a4cbd6c1511e802e56b77408581f9af567326f"
    sha256 catalina:       "8eb83388db58c42ae00a343e1382c52948c5b203ff754fed7b6582eeb989fa3c"
    sha256 mojave:         "d7f05f3fc8eb5c0c3f3a5a66bf4d43262a84ae1edaf7ec92897122fd069e4a96"
    sha256 high_sierra:    "b7394034b2898da9e7a61d578f9789f642f29d3191f84041b4fb9763bdfdcc73"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<~EOS
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
