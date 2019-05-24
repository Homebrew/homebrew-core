class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.16.2/aide-0.16.2.tar.gz"
  sha256 "17f998ae6ae5afb9c83578e4953115ab8a2705efc50dee5c6461cef3f521b797"

  bottle do
    cellar :any
    sha256 "53b1dfabc76d6e54db56ec24f7f91b6cc9dcdd18210d17d2df92f86225fb9c9f" => :mojave
    sha256 "79a2d4ce92526516891c844a4852161d39421f9dc31d2eba5ea0e48d79496053" => :high_sierra
    sha256 "b626fcf7e52a0ea66fbed58bdc00cb08484f7bce8e84e61edf6740fbad7fabc5" => :sierra
  end

  head do
    url "https://github.com/aide/aide.git"
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
