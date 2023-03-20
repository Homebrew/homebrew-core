class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.1/aide-0.18.1.tar.gz"
  sha256 "158e72e2fc7f08cb28b66dd5988294c19b035b5a901d7ad5fee010efeca4c0d2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f102f78ad23f15ca288e8b63e1d62d5947c05718035de12b6795c3e56aa23b8"
    sha256 cellar: :any,                 arm64_monterey: "9a9bfe81defd498fb21cb240f9990a9a91e23e0784e2f8e3a3e78d38fd996b6a"
    sha256 cellar: :any,                 arm64_big_sur:  "22351539a992708cc2e1163f7458d60d45d01397390ed80e7350d1adee045c4f"
    sha256 cellar: :any,                 ventura:        "7c2a421c631e48b867f8ffe8a08b0d3a136d0c66d3ab6bd4e7f5b314db0a959c"
    sha256 cellar: :any,                 monterey:       "05eb9419d868d36ea51a510a8be97a7d8b471b74ae89c0b1bb6bad74be304e1a"
    sha256 cellar: :any,                 big_sur:        "b02e20164f8a94ee9c77c8122eddffbf0db10cd488d3bf7506f23a32241237f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c6ed7475082453db50fb020e8b98e7aef1d5b9d643a99c2e76446e35b628ec"
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
