class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/aide/aide/releases/download/v0.19/aide-0.19.tar.gz"
    sha256 "e7fba0214be01299d76359bff2975233ed241332e4cfcfff59cd1b6a89aba5e4"

    # Fix to missing MAGIC Constants for linux, remove in next release
    # Issue ref: https://github.com/aide/aide/issues/192
    patch do
      url "https://github.com/aide/aide/commit/3a218b2a3affe034bb51506fd0b770eab723ca95.patch?full_index=1"
      sha256 "6136c77d4242664a9df9ae9daa62a96809aadb21875655b705b4f2ea1e6cead8"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "758e74004bbc5c324e8d762b0bdec6632d817125346c092126784efc5195a503"
    sha256 cellar: :any,                 arm64_sonoma:  "996cfa72645cfd7cbf3e543e9dd2b562d33f6809f66f795e9d52f1747f49b27e"
    sha256 cellar: :any,                 arm64_ventura: "2eabc4523a770502710a4cc759fa9b1f21dfef43616c38fa7f8076c2ae679963"
    sha256 cellar: :any,                 sonoma:        "fd0f7276bedd9c50e33b07770656dc69cc9a408d0acf499b27c85d2ab42ad06a"
    sha256 cellar: :any,                 ventura:       "b84e1f1c9b88e3fc1a9588ce0d59e11dc9af323b2c54454511ec8022ed2357ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2fb38a54ef59390ca2b5161a839983818eea34f11d50c4909b66eba395ee96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "020f57203ee46e492a1a3a8e2fbc207757aba784dc14118ffb85f04c98d371ce"
  end

  head do
    url "https://github.com/aide/aide.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with cask: "aide-app"

  def install
    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
    ]

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
    end

    system "./configure", *args, *std_configure_args
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
    system bin/"aide", "--config-check", "-c", "aide.conf"
  end
end
