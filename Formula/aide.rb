class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.16.2/aide-0.16.2.tar.gz"
  sha256 "17f998ae6ae5afb9c83578e4953115ab8a2705efc50dee5c6461cef3f521b797"

  bottle do
    cellar :any
    sha256 "bb68fa349609a0221b2138e3596ceb803242862b771bb0b76440057e31201050" => :mojave
    sha256 "fff1a3e469346d9181f73d8c3d734801b900c765308f3c36495b1801fb3ad897" => :high_sierra
    sha256 "77aef168355fa73b01b0967d80058582f7387997ba2c7f7b7aad0eb335939488" => :sierra
  end

  head do
    url "https://github.com/aide/aide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"
  uses_from_macos "curl"

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
