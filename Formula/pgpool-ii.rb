class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.2.tar.gz"
  sha256 "3e6c788e70f0672c7b38c88a6ca76f31f3786b125689980cc063ab752ca58234"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c4401a7f0c1ff1376b3d083e87f69b753c22f66202f4c334f6910300fd3c446c"
    sha256 arm64_monterey: "033549edb31207d6cca5d921d5f46cc6abc22a040f94879b9816ca936c2bda7c"
    sha256 arm64_big_sur:  "25b0107aab61a6c15f8264049f88a04cb72e529b2e580dde5687ca5ff1a0fc7e"
    sha256 ventura:        "09dcdde328cf0b23f553367a831053336fa8629339f0af9d6a29782af1103780"
    sha256 monterey:       "10a02d1840435c7a445d63c8effa529c047ff76df6c0773bdcd002222b5f45b5"
    sha256 big_sur:        "0af63ae746d020b2caf2461cc6ee3cf5f0fd931e5951396c85c0f30c7b2347fa"
    sha256 x86_64_linux:   "4c31f8e1e0c1c442f50a2f6a72d87d03d9405f1134fba894ef7b4c147af3645d"
  end

  depends_on "libpq"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
