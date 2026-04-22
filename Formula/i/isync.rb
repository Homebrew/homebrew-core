class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.5.1/isync-1.5.1.tar.gz"
  sha256 "28cc90288036aa5b6f5307bfc7178a397799003b96f7fd6e4bd2478265bb22fa"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "112d7d4dd67530267fd137c2a4dc088128cfb86645df9baacdf347657f638779"
    sha256 cellar: :any,                 arm64_sequoia: "0f5182fcd8741c7a5206d2dbe599e4ae4d69af77e9cfd6fce910fb73da81790b"
    sha256 cellar: :any,                 arm64_sonoma:  "27e9a03df42264de7db35d52232a1752051caee2ab0eeead25e16d81c026cf9a"
    sha256 cellar: :any,                 sonoma:        "a0ced90c4006994b8a962ff402b1580aa27f821193aaec168562f08eee713c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb02c3cdc9fdae85acc97a271031a4fc62b23241926f3cd905f2d201a21f1e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328a896bb3825d07bf63b0650f0031fc1a0ff7c44a785952cf3c29f88f53a881"
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db@5"
  depends_on "openssl@3"

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin/"mbsync", "-a"]
    run_type :interval
    interval 300
    keep_alive false
    environment_variables PATH: std_service_path_env
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end
