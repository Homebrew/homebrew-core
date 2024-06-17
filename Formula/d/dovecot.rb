class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.21.tar.gz"
  sha256 "05b11093a71c237c2ef309ad587510721cc93bbee6828251549fc1586c36502d"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b3d70604dcf10caaf9cf9505f3bd90ed48bdee2ba891ef891ae1c10fe0a7a4e2"
    sha256 arm64_ventura:  "b89589ccfe9620e87c163c99ed504fb875585dd23d4a53487dc7935b02866c0e"
    sha256 arm64_monterey: "5ae2a7172bf487a36f90ee0115e57572f7a52e5b1dabdfd8929ee4f01b78d2be"
    sha256 arm64_big_sur:  "ff928eaeb4ec664bd5e8cba3060a4745a9f6a34f667ff288e0f119c930692f3a"
    sha256 sonoma:         "5f21b1c455dc089610cf936add3d7e6c3318da234aa945c3e98191663b9b6022"
    sha256 ventura:        "5c6db5e542ce460ccfc2168b3f14ec80279a621cd076fc5836bad88eb93f5d55"
    sha256 monterey:       "dd17baa57200f7d95ebc5f8870cca4cf9e48c570840e42c9b1f51d02ec1dbbec"
    sha256 big_sur:        "e3cba8498560c19191205b503aad5093a1dde6bf45c3e01319f94d89f554321d"
    sha256 x86_64_linux:   "9740a847f5221216150086de18bd43e93500f6d988ad8989f9f98f9458392097"
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
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.21.tar.gz"
    sha256 "1ca71d2659076712058a72030288f150b2b076b0306453471c5261498d3ded27"
  end

  # dbox-storage.c:296:32: error: no member named 'st_atim' in 'struct stat'
  # dbox-storage.c:297:24: error: no member named 'st_ctim' in 'struct stat'
  # Following two patches submitted upstream at https://github.com/dovecot/core/pull/211
  patch do
    url "https://github.com/dovecot/core/commit/6b2eb995da62b8eca9d8f713bd5858d3d9be8062.patch?full_index=1"
    sha256 "3e3f74b95f95a1587a804e9484467b1ed77396376b0a18be548e91e1b904ae1b"
  end

  patch do
    url "https://github.com/dovecot/core/commit/eca7b6b9984dd1cb5fcd28f7ebccaa5301aead1e.patch?full_index=1"
    sha256 "cedfeadd1cd43df3eebfcf3f465314fad4f6785c33000cbbd1349e3e0eb8c0ee"
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
