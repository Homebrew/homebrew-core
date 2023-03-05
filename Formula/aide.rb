class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.1/aide-0.18.1.tar.gz"
  sha256 "158e72e2fc7f08cb28b66dd5988294c19b035b5a901d7ad5fee010efeca4c0d2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b806defe2e638ecb625e99493844648d13eb73fe7f4d6447e6b00fd38f9fe60"
    sha256 cellar: :any,                 arm64_monterey: "b45e9aded2b3e1588b5990dd18de49f9e3e7e7bf9ecf5f6276d1e9895899cc5d"
    sha256 cellar: :any,                 arm64_big_sur:  "aadba4f98c0595cc3331430b1ce02d8dd1806b25e56b05161efea091f8be55c5"
    sha256 cellar: :any,                 ventura:        "1ea3996fb6343a8167185e8c73ef9eb5ed239b2751d3b0113b997690eaac1495"
    sha256 cellar: :any,                 monterey:       "740c26430d95559f962d33123c885dcceb4cd015802de92fe27dcb14d655329a"
    sha256 cellar: :any,                 big_sur:        "c878bc2f73d229a2c6ace06c106be9e007669e5abffabe69640dc212ac7287b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57c932f6e2b90d85326e1627667616b465840699967a2f0eec4c170cd284fcd"
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
