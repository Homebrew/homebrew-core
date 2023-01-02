class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.20.tar.gz"
  sha256 "caa832eb968148abdf35ee9d0f534b779fa732c0ce4a913d9ab8c3469b218552"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7151ef7284fca75a23eea4ab0c2a3700290636e8086c3494d64d90115aa1a466"
    sha256 arm64_monterey: "3513089f8545a1711e9e081ea1cf08b348d1ef0bfdaaf0b547d4c430baddbb01"
    sha256 arm64_big_sur:  "6abfc253e93bdec5dec1c16a0dfeed652dcca7dd76e3df24ed6ee87c422f6669"
    sha256 ventura:        "79ae6da26f29ff828a9d263af79ee897f0bdebed173853fd38e7829c69494761"
    sha256 monterey:       "65dfcf3875ad30e9c2db39e1a73bc80e29bac029e23eb257f303d432791a48e0"
    sha256 big_sur:        "37e9981cca504a07add3782b8c4f6b3ba56cc6cf196fddaae041e32a4512eef2"
    sha256 x86_64_linux:   "faa27190c25ee0f2e8e7bcd2793fd4679cb6e9706430925ca9cb2682eb3b4d72"
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "linux-pam"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.20.tar.gz"
    sha256 "ae32bd4870ea2c1328ae09ba206e9ec12128046d6afca52fbbc9ef7f75617c98"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-pam
      --with-sqlite
      --with-ssl=openssl
      --with-zlib
      --without-icu
    ]

    system "./configure", *args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --disable-dependency-tracking
        --with-dovecot=#{lib}/dovecot
        --prefix=#{prefix}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  service do
    run [opt_sbin/"dovecot", "-F"]
    require_root true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/dovecot/dovecot.log"
    log_path var/"log/dovecot/dovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")

    cp_r share/"doc/dovecot/example-config", testpath/"example"
    inreplace testpath/"example/conf.d/10-master.conf" do |s|
      s.gsub! "#default_login_user = dovenull", "default_login_user = #{ENV["USER"]}"
      s.gsub! "#default_internal_user = dovecot", "default_internal_user = #{ENV["USER"]}"
    end
    system bin/"doveconf", "-c", testpath/"example/dovecot.conf"
  end
end
