class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17.1/aide-0.17.1.tar.gz"
  sha256 "a401c951938f1169ceaec868ce3594736e89c5c881578c263d8a824a06b0002d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d95d123bfb33e1d42ed6a47cda73d62a05e31a635bf4b35b86225c1e68daa5d6"
    sha256 cellar: :any, big_sur:       "f405f1835d4baebec9ab71892154f8be7e49b3675a72a253bac0362001bec6df"
    sha256 cellar: :any, catalina:      "c3e7c313d1fa123f7c141bb49e9570325ecc161e867c5af6660660640fa2b568"
    sha256 cellar: :any, mojave:        "d6a35681437639f1334c52bb96cf2b9ce14c82f8cacbea393f1cb4e098a88473"
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
