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
    rebuild 1
    sha256 arm64_ventura:  "c9e2fc781d0b0a896294e5619d85d19c0d01d0d4e5a833e6b380ba792dc2fa2c"
    sha256 arm64_monterey: "b911df521e2e6961d5db4553b92e009aa9cce6f84d3fb7a5d5fda0115e3c8355"
    sha256 arm64_big_sur:  "4c0cacdc42c3170b298fc0a88f5085a51a51ee052b04956fe2d1067b630a0819"
    sha256 ventura:        "81a94d994329d3a3c8b2ff8f1774a280ae54330174bd1dfad2826fec54287a7b"
    sha256 monterey:       "b323934b7d27693e28a8d0047576dff6f8029d721e0d6d5d97d6b1afeca30a4a"
    sha256 big_sur:        "0c9fbdb439b3e781d23ecc4a4f65c81f11ad6a3d238d217eae5918916658bf61"
    sha256 x86_64_linux:   "8a23a5a515f5f09cc8bbfc9302cc4e0d9cb23ed3368a5eb0241edaded1882759"
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
