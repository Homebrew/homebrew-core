class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.4.3.tar.gz"
  sha256 "46745aa98f454e097cecb4dacf536f89c37ed3ec41f32f0a846934229d0eb733"
  # NTP license that excludes distributing "with fee"
  license :cannot_represent

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "235dc70c704b788d49206e4a1deadff5a0d58498237e2ce83b281728e6567600"
    sha256 arm64_monterey: "acd26bdaf1c533c86ef58212eab3f56b421ef754d6c88687dab5b0eb9bf735ae"
    sha256 arm64_big_sur:  "963be0b64f64f58288375b06151e469554ac2d08b412d2ea80feb4b86e5c9eb9"
    sha256 ventura:        "c6d84c3bbf033dee5a4c0d90d4cbd08d7938e1de2053e3e8f988289bff7cf8a4"
    sha256 monterey:       "3c2408df6ab19d06bd7c5b41d75e5413d2cad58d793df65bfb352666ecbd3668"
    sha256 big_sur:        "830a2744c52714dcef82d2a74c8b4bc642c5e86d3d6f245013a650593ddd14a2"
    sha256 x86_64_linux:   "917dc27d2774739b6ece0eed30b6a341af9ebf19e4e04067fa5820b23d34b3b1"
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
