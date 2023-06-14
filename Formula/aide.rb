class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.4/aide-0.18.4.tar.gz"
  sha256 "4f7e2c7f49f3ca25fdafad6170390a4d8c8334af17bbd48ad34dbd6dde4ee757"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b280c7372b5e9d1fe9473e8e9cc367d5a2ca8ac2b120adcc905953ddfe692c0"
    sha256 cellar: :any,                 arm64_monterey: "b0c2a2ca9036f40ebbb8b2bdd7307cfd6fd1c805c6e00a446e2c41eaf1c98130"
    sha256 cellar: :any,                 arm64_big_sur:  "f9437e7a8f49f36246a04de68be54b370fc79b8ff0d39da2e79b7d58a98dfea2"
    sha256 cellar: :any,                 ventura:        "4b8f70c54a4443334ee4125d7ba432c4b1bbb6ad45e5ba44ed26bb5f83e40476"
    sha256 cellar: :any,                 monterey:       "f71d708089e7669344c6d88b4fb00ca4bd186c64d8ade15cfd011419ec58795e"
    sha256 cellar: :any,                 big_sur:        "dad4b5ee89d76e96dfa495f4f84a2183d76a7fe188731dce84f202afff3a2002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680786c45d1ce272fde46408378959b6cd2109de8c105dd0629e67f4ce686f33"
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
