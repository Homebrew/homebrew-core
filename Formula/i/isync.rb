class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.5.1/isync-1.5.1.tar.gz"
  sha256 "28cc90288036aa5b6f5307bfc7178a397799003b96f7fd6e4bd2478265bb22fa"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "679faf8c8def86ce0224c4f1edbff742549d5a7f7ec1389f30c5b9d050844fce"
    sha256 cellar: :any,                 arm64_sonoma:  "4e4510861b03a2ccec9b01b0136ddb6ed903db1d53e8691ebf7606f225d5eb40"
    sha256 cellar: :any,                 arm64_ventura: "130456630d195bea122ac91aded7cfa8b4375bb954325f4b0806b73322125978"
    sha256 cellar: :any,                 sonoma:        "51ee82083ce5aae9883f444fe52aaa26c43d0856e587ee7755b2a4d132dfabe9"
    sha256 cellar: :any,                 ventura:       "cc88915ef3a70a61e83952548559a3d6879561063b0826566851e0c1b3ae0a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a485ffab93aec68e2643810d101ededa1de3ce47f1fba32b69a525f72ba52691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7f6e94602fe5a7812e8c8731ddb620827c950199116ecd10b22f24040cf6d0"
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db@5"
  depends_on "openssl@3"

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
