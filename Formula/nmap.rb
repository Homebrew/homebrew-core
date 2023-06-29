class Nmap < Formula
  include Language::Python::Shebang

  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  license :cannot_represent
  revision 1
  head "https://svn.nmap.org/nmap/"

  # TODO: Remove stable block in next release.
  stable do
    url "https://nmap.org/dist/nmap-7.94.tar.bz2"
    sha256 "d71be189eec43d7e099bac8571509d316c4577ca79491832ac3e1217bc8f92cc"

    # Fix build with Lua 5.4. Remove in next release.
    patch do
      url "https://github.com/nmap/nmap/commit/b9263f056ab3acd666d25af84d399410560d48ac.patch?full_index=1"
      sha256 "088d426dc168b78ee4e0450d6b357deef13e0e896b8988164ba2bb8fd8b8767c"
    end
  end

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1fb5366d5ff0a6dff4aca4854b35138eefe8f447b89e63cd6bacf709747cb7b9"
    sha256 arm64_monterey: "fcbded0558154451e4d2bf9dc0526b1e6eafbfd00cfee631071b875058c8ff05"
    sha256 arm64_big_sur:  "bb0cddc6143f47f80f51cc055da7fea7124ba56c06c541bb166d98806d611904"
    sha256 ventura:        "5b384ad6e81ff105b5530aaee7ddf2b8f75dd171d5601c4b58e9951a28b6c19d"
    sha256 monterey:       "28593488b9872c097b031b1ee7d4be30935a61068e5c26fd55e664008674874b"
    sha256 big_sur:        "1fcfff20b13972811c7d3cc33cd6e3a6dd01f1a4fad0fed3ebb4432dbeb5b765"
    sha256 x86_64_linux:   "8be3c481551f967c24ad48945f33d1da0b305ab78a8d09d45142ba73c3b9ae93"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
    return unless (bin/"ndiff").exist? # Needs Python

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"ndiff"
  end

  def caveats
    on_macos do
      <<~EOS
        To use `ndiff`, you must do:
          chmod go-w #{HOMEBREW_CELLAR}
      EOS
    end
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end
