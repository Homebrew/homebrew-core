class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.4/isync-1.4.4.tar.gz"
  sha256 "7c3273894f22e98330a330051e9d942fd9ffbc02b91952c2f1896a5c37e700ff"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/isync/isync.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c218fe3f0a32e6b92575ea508a02bfd1ad97574526f9c2ed5711aae2c447d26a"
    sha256 cellar: :any,                 arm64_big_sur:  "7d62490dde63229ca06419e7178e13e8197dba53695c08de3f1a561814d5b808"
    sha256 cellar: :any,                 monterey:       "d40f4b9b028d2f87b2278fa9f8012dc5262c574041454858de970082059f478a"
    sha256 cellar: :any,                 big_sur:        "4f688d29553610b29be265fe2078cc53b842b1c466cb72cb266c8c839240e54d"
    sha256 cellar: :any,                 catalina:       "2d15adbeb9a739af8bf729f08b8277cafcea4d9f031600e01efd8359cef287f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a40c0b2101f61fe74f4d724a9763cbd777ee00f82d8276603195988830b6451"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Regenerated for HEAD, and because of our patch
    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "-fiv"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_bin/"mbsync", "-a"]
    run_type :interval
    interval 300
    keep_alive false
    environment_variables PATH: std_service_path_env
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end
