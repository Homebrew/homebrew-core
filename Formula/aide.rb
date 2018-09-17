class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/aide/aide/0.16/aide-0.16.tar.gz"
  sha256 "a81c53a131c4fd130b169b3a26ac35386a2f6e1e014f12807524cc273ed97345"

  bottle do
    rebuild 1
    sha256 "0c952b922666c241fd3fe1249b29bf88c2149378511218d76dc30de1097a04f1" => :mojave
    sha256 "c9429f028f2627c8ae1b76737b26741cecc4c18507139b02bcc6c487bc5e15a7" => :high_sierra
    sha256 "71d151f2f389cbbc5884eff30261d0691d020c0983411962c1ba42927d0ae052" => :sierra
    sha256 "2860850684659f15f8d5dc01127a7a9f2bfc21f773d99c4a8897585b4542723d" => :el_capitan
  end

  head do
    url "https://git.code.sf.net/p/aide/code.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
    (testpath/"aide.conf").write <<~EOS
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
