class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.95.tar.bz2"
  sha256 "e14ab530e47b5afd88f1c8a2bac7f89cd8fe6b478e22d255c5b9bddb7a1c5778"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "79e86674984301bb84449e67ca155af2009dba475e4609c6671dc73e7112961c"
    sha256 arm64_sonoma:   "cdafb01815d04428742bca04ecd329522933c578bcac7c7210fc92bd7e36cedf"
    sha256 arm64_ventura:  "948c11d0d852890c2d331674ceee73615fd645daee551b40351045eef48b4411"
    sha256 arm64_monterey: "2b5079654dc3ab7d015d4eb8aa17a127acbf96a24fca651c7bcaeeb7e0f68d9e"
    sha256 sonoma:         "773bf1c00d07c15f837efeffe68b2c0606fa0dae27aaa23e830d340b4cc09706"
    sha256 ventura:        "3273343599a31092f05c677a803be118332eb39fa2c2f0defc4a68883d19be5e"
    sha256 monterey:       "9ed369a7f81ba3c7c0396e0645ac77173dfb31ddba16cbcfa8faece61a29e2af"
    sha256 x86_64_linux:   "6dd2f9435f92feb161180cca78a46c323c78e252f4107a709c5355e275516422"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    libpcap_path = if OS.mac?
      MacOS.sdk_path/"usr/"
    else
      Formula["libpcap"].opt_prefix
    end

    args = %W[
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre2"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-libpcap=#{libpcap_path}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args, *std_configure_args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
    return unless (bin/"ndiff").exist? # Needs Python

    # We can't use `rewrite_shebang` here because `detected_python_shebang` only works
    # for shebangs that start with `/usr/bin`, but the shebang we want to replace
    # might start with `/Applications` (for the `python3` inside Xcode.app).
    inreplace bin/"ndiff", %r{\A#!.*/python(\d+(\.\d+)?)?$}, "#!/usr/bin/env python3"
  end

  def caveats
    on_macos do
      <<~EOS
        If using `ndiff` returns an error about not being able to import the ndiff module, try:
          chmod go-w #{HOMEBREW_CELLAR}
      EOS
    end
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end
