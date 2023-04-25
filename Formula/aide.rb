class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.2/aide-0.18.2.tar.gz"
  sha256 "758ff586c703930129e0a1e8c292ff5127e116fc10d0ffdbea8bf2c1087ca7e4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "171e10bfebd4fd1a8fc99fa342d13e827655adddef337227e09c4d10b297e0bd"
    sha256 cellar: :any,                 arm64_monterey: "f61823b4de2a03ae26bfd06f46bcf56f0301db56517e944b5acd1281ac9a0262"
    sha256 cellar: :any,                 arm64_big_sur:  "069c56f58a38a8221d49245087c9cb0c1b3c01964b4231e652f7e7422d4fb691"
    sha256 cellar: :any,                 ventura:        "f696d2c3cd3746034c25b58bcf7fb36ecb3da8e2b2a89d493ba2f152e4ba0e82"
    sha256 cellar: :any,                 monterey:       "f89ad08612238984e94760dad56ec3da4df1a27277b31fe4bf3d9ccecb5a7f0e"
    sha256 cellar: :any,                 big_sur:        "c0a9200dd91e91d2a754791b1a80ef1f6439d1f76ef503c2a48bf2a52cc9ed97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c3072663278ebd03c6c1df85fa269c83254dd3397f48acf087a2167ccb397b"
  end

  head do
    url "https://github.com/aide/aide.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
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

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
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
