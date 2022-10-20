class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.19.1.tar.gz"
  sha256 "db5abcd87d7309659ea6b45b2cb6ee9c5f97486b2b719a5dd05a759e1f6a5c51"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]
  revision 1

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "84ae37c002fb903dde0682cef958f5ddd49c40f4d61b0afd4ad1f602837b85c4"
    sha256 arm64_big_sur:  "eab081f7f434e7934e789d5e2992312086df91a80e90bcdac70d0ba5f6fd4a7e"
    sha256 monterey:       "4c116a281b03d57bd4e40ba70020b30278089b77fac4d406786084335be77251"
    sha256 big_sur:        "70f94514c6a5bb9e212cedf96b6cbf99344ce02264a7fcfaa3890448ee70d236"
    sha256 catalina:       "afe4a6433bedbcbec98524c59aaa204a66dbb78ac00936358539f30c1328dcac"
    sha256 x86_64_linux:   "1ee5b6d7968f2d764ad21f892e8d30470c818dc6cd8fb0a184b8510a43bb317e"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "linux-pam"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.19.tar.gz"
    sha256 "637709a83fb1338c918e5398049f96b7aeb5ae00696794ed1e5a4d4c0ca3f688"

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

  plist_options startup: true

  service do
    run [opt_sbin/"dovecot", "-F"]
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
