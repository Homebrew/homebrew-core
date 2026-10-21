class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.5.1/isync-1.5.1.tar.gz"
  sha256 "28cc90288036aa5b6f5307bfc7178a397799003b96f7fd6e4bd2478265bb22fa"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aac10990f0035a59af38824b644835090f4f40d35e74b1ed8efdd164ec3c9a8d"
    sha256 cellar: :any, arm64_tahoe:       "b4c6e597e2d119bc81bf052a2c25ae0a648692e987d144e0e4752bd806e91f7b"
    sha256 cellar: :any, arm64_sequoia:     "ebf1eb759ae36f017092f94daa95c07ead59c8de411e5a2c81aeddac3591368e"
    sha256 cellar: :any, arm64_linux:       "4e9e22c05eef3b1bdf41704a5f05c4859ab0ef0fd50603d30795a52c4aa53993"
    sha256 cellar: :any, x86_64_linux:      "e18321686c530f9067cbc9ad990476437cbaf235b2e841d3d741ed0265e6759b"
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db@5"
  depends_on "openssl@4"

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport fix for OpenSSL 4
  # https://sourceforge.net/p/isync/isync/ci/bdd9ff8d931236e1926a58cb44bd2644e4538217/
  patch do
    file "Patches/isync/openssl-4.diff"
    type :backport
  end

  deny_network_access!

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
