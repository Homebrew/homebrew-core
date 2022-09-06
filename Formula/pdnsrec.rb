class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.3.tar.bz2"
  sha256 "206d766cc8f0189f79d69af64d8d937ecc61a4d13e8ea6594d78fe30e61405f2"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1370c51e5a898afba929675c613df52001628620c34fbb45d17b1582f93e85a0"
    sha256 arm64_big_sur:  "b1ad7ad29d974bf1e335896e70815eba288bd69abfd064b8825684d48dea5518"
    sha256 monterey:       "4e06950a4dbd360831c86e10f62e5febfe44c2c6716252696326929310d94dca"
    sha256 big_sur:        "63b740667d0a0467bcc51f3a448704dbb994cb94b6ce2166a40e786d58c82428"
    sha256 catalina:       "0d06dbbfb6ec266a35b56d43d8038df19c2b720a264a590da7bd3741e7175f5c"
    sha256 x86_64_linux:   "e84247ad57c058232d8fa5bcb0443dfbe6a82cf5b708fa0a2a43ddb7f9061e03"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  on_macos do
    # This shouldn't be needed for `:test`, but there's a bug in `brew`:
    # CompilerSelectionError: pdnsrec cannot be built with any available compilers.
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
