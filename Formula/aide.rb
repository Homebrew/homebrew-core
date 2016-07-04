class Aide < Formula
  desc "File and directory integrity checker"
  homepage "http://aide.sourceforge.net"
  url "https://downloads.sourceforge.net/project/aide/aide/0.15.1/aide-0.15.1.tar.gz"
  sha256 "303e5c186257df8c86e418193199f4ea2183fc37d3d4a9098a614f61346059ef"

  bottle do
    cellar :any
    sha256 "ed398a49873201175ca83f9bb467b975e6ae5ce114c644689a6372f5cd9d37fb" => :el_capitan
    sha256 "e4a9afb7f03a1a66d29fb3fde36082745922e3b7de9718a90bfea7a259518caa" => :yosemite
    sha256 "d723494937ba8af946f24bd1c03501d6787655b06173fabbbfba2fbddf2026a3" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/aide/devel/0.16b1/aide-0.16b1.tar.gz"
    sha256 "35d99899d8b7cd723ac744b8cbd8d5f911ec22a4b568134dd0b6f7116d21b566"

    depends_on "pcre"
  end

  head do
    url "http://git.code.sf.net/p/aide/code.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "pcre"
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"

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
