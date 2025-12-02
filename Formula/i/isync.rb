class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.5.1/isync-1.5.1.tar.gz"
  sha256 "28cc90288036aa5b6f5307bfc7178a397799003b96f7fd6e4bd2478265bb22fa"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "51ac23702b00a76b69d7b7a5a2a49e12a1dfdec10d39eba583456af95a1e5b24"
    sha256 cellar: :any,                 arm64_sequoia: "87e89cf7ba0e8017e911fac5e775caf4f87a13c4446feef4036b68682d297318"
    sha256 cellar: :any,                 arm64_sonoma:  "351efb217c463419e3b6f6955416904a75391b3b6a48d78694c2cdba516679fc"
    sha256 cellar: :any,                 sonoma:        "374da5a258a54405bcfc02798557deb06477dac7b5d3377ffbea83d23bbfa869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3bcb74523494f0e6f3c56e0042c166f5fed1566fb3b9890aa9d5c2837655a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b212a214d32232c91c5bb140d8ee04af558b87864e7514737cadd4cf8b9f93c7"
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db@5"
  depends_on "openssl@3"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
