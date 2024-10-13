class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.5.0/isync-1.5.0.tar.gz"
  sha256 "a0c81e109387bf279da161453103399e77946afecf5c51f9413c5e773557f78d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "70e342b7ba66bbe8a88c7bb630d2f50efb9acc192b62d605791bf53c39fda2b2"
    sha256 cellar: :any,                 arm64_sonoma:   "e48cd1bef8b1a3f355cee8efacac1242108d9b1218944316854c42fd52cc188a"
    sha256 cellar: :any,                 arm64_ventura:  "7393f7064f2a12a808527a5fd796231ec7cfe4d5ecfe103a5c61567e656f0203"
    sha256 cellar: :any,                 arm64_monterey: "88124980b8f9888a48555fcba7e9a713280e5215f196e8b9ebbb42e63890cbd0"
    sha256 cellar: :any,                 sonoma:         "742d3299abf0a6d07273413be8ba0045cbd4900bb394c2276eec0dc0814f238b"
    sha256 cellar: :any,                 ventura:        "7315d82bf2b34a7ce8cee3380e0b072ff10e209f63b63f54d11e3a0a50207178"
    sha256 cellar: :any,                 monterey:       "098a45ed674955e0182f538a5cd8766c6f9878e8f89d64a27beafd5f1a4efa9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d879d13ee7d3d61649e167a19460d47e2a2a7153b4840aa68a99623e85c686f6"
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
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end
