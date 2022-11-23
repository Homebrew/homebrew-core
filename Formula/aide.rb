class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17.4/aide-0.17.4.tar.gz"
  sha256 "c81505246f3ffc2e76036d43a77212ae82895b5881d9b9e25c1361b1a9b7a846"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da63a166bd78f49ae0459e96f2f98ceda43ae418c9e5430e3641d3cf37499a6d"
    sha256 cellar: :any,                 arm64_monterey: "b0c84efe8e1900637012961de81510d4b161add9251fc83614141cc149e0c575"
    sha256 cellar: :any,                 arm64_big_sur:  "7d5c7b012260f55372992d7e692f53c72d14e8b265db4869af5641f0b44f8435"
    sha256 cellar: :any,                 ventura:        "81772e8128742974468566cf527a3335495bc5b6c4c8189ad88c80fe33bf200a"
    sha256 cellar: :any,                 monterey:       "f19c632ec5e607e4fa4687cc3b49f644d678a957e93ab5e74df37c51df97203a"
    sha256 cellar: :any,                 big_sur:        "c619712d6930437e597f599e5e62f0047fd9ce985aae1ed964d1cc5a03fdf5ef"
    sha256 cellar: :any,                 catalina:       "aa1ae5486d07a19d0729947adcc180518ad1b6a46fc29c0b450e95868b80a05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef25683c89e216c309bd49f0422a83111ca6535e695822b3962cce5ed77bacee"
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
