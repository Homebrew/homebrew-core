class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.8/aide-0.18.8.tar.gz"
  sha256 "16662dc632d17e2c5630b801752f97912a8e22697c065ebde175f1cc37b83a60"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67de729676b7cef9aaaed2c7b206a7786f6ef9ea9c4afc01b618aff46dcc2b18"
    sha256 cellar: :any,                 arm64_ventura:  "28b109731344ff7448929640721cf9b57b75147dc48552952090adb11e086ab5"
    sha256 cellar: :any,                 arm64_monterey: "50ac76fbb9fdb0ed794ca4def350631b9c297c20635c8609c8efd19b5dd5159c"
    sha256 cellar: :any,                 sonoma:         "a7a43ce551b4cc61a6b23e011a6114fadbb2c86f7c1266623f327d4e4ae738f1"
    sha256 cellar: :any,                 ventura:        "d9693e7f65cd11f1195eedecc860b385f556b57e3d700b9cc5758c819aa062dd"
    sha256 cellar: :any,                 monterey:       "68c94e713f48b7633df19a440444043e8e64c6f93a125d062d4ba33c12737c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5f708845d27bd45bdaf4780d901964e206f9202da0be92f66e3a85e9d849c7"
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
