class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17/aide-0.17.tar.gz"
  sha256 "4fd88d1d5ddc70c698c6519ebbc05c8d32c3f6d8137bbfdefeaebaafd6db867b"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "1b41deb51dc2a93fe7cc9636423170bcd7410c555d76d14d723142088ab236d2" => :big_sur
    sha256 "2f0181e158a1a2eb318f453534ca37418d102508525cfd090cc1405c3e7f7554" => :arm64_big_sur
    sha256 "ffc37c63e0b9511714e4c29030c765239a203de201aebc297dc77019eeacce8b" => :catalina
    sha256 "aed7265c6f9b83234b08790276d9e4b8fd2e8c2def9e3641c81310bb56fa1a23" => :mojave
  end

  head do
    url "https://github.com/aide/aide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    # fix `fatal error: 'error.h' file not found`
    # remove in next release
    inreplace "include/aide.h", "#include \"error.h\"", ""

    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-lfs
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
      --prefix=#{prefix}
    ]
    on_macos do
      args << "--with-curl"
    end
    on_linux do
      args << "--with-curl=" + Formula["curl"].prefix
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<~EOS
      database_in = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      report_summarize_changes = yes
      report_grouped = yes
      log_level = info
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
