class Aide < Formula
  desc "File and directory integrity checker"
  homepage "http://aide.sourceforge.net"
  url "https://downloads.sourceforge.net/project/aide/aide/0.16/aide-0.16.tar.gz"
  sha256 "a81c53a131c4fd130b169b3a26ac35386a2f6e1e014f12807524cc273ed97345"

  bottle do
    cellar :any
    sha256 "0d1525d760a47f0d9f331365724748f49b648a791d13354a1f54b3977e0eabbf" => :sierra
    sha256 "ac9b57a6912ac73ccd6bdb013842168f0d77a597ead54bff0640db6e2d0e49d8" => :el_capitan
    sha256 "0def5269c4525296c167ceb591be1f69f4d65151da7bd9ef9a25160e5ca6e0a6" => :yosemite
    sha256 "96addc96a4768e2343e2760022e115404c80b54b64f160925d24447bb393f39d" => :mavericks
  end

  head do
    url "http://git.code.sf.net/p/aide/code.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"

  def install
    system "sh", "./autogen.sh" if build.head?

    system "./configure", "--disable-lfs",
                          "--disable-static",
                          "--with-curl",
                          "--with-zlib",
                          "--sysconfdir=#{etc}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<-EOS.undent
      database = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      summarize_changes = yes
      grouped = yes
      verbose = 7
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
