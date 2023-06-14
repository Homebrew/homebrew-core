class Nmap < Formula
  include Language::Python::Shebang

  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  license :cannot_represent
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
    rebuild 1
    sha256 arm64_ventura:  "b7ebbfb35120ebf567c3e022edf5cfcfa500859be1c985a0fc1aec9bd8c3fd29"
    sha256 arm64_monterey: "5f50b15612375e48007d70a646ad4d19436929d875dc6536d94d1c83b8eca448"
    sha256 arm64_big_sur:  "ff49e2d26c535ea8c146fc4d4dea8d6ebeb0798e404b7c501c836e9c0c3d0ef5"
    sha256 ventura:        "722752a91b928c957cdeadedea68300617f5f84e99aae3f3df6ea34f2b76cf8b"
    sha256 monterey:       "4a1b956d9b12ea5b6c957ceedc71d3ff77911d4759ccf9cdfb3f1e828f21bcb3"
    sha256 big_sur:        "ba29aa64ba09d5e8faefb4e29d616f50ab26449c15dcd8a163d1ea7ef75f959b"
    sha256 x86_64_linux:   "0fecd65a60b067340fd9b0d47e4bc73344719fc8f5cb6f4d6662a68a4e6f5568"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
