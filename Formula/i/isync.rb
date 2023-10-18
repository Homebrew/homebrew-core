class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.4/isync-1.4.4.tar.gz"
  sha256 "7c3273894f22e98330a330051e9d942fd9ffbc02b91952c2f1896a5c37e700ff"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "fa5785b8d75e9d791f88667a8bb3419c4d23d470e5eea0e66ab01d38850cbbb2"
    sha256 cellar: :any,                 arm64_ventura:  "e4e43c921a44c03f8e2e8023a1d7c381318ad5185ecfe7d9992f50afd7fb4152"
    sha256 cellar: :any,                 arm64_monterey: "816db2393272d941460076dd9407191c669fb1fa95c23ffeb428645e7e18bf00"
    sha256 cellar: :any,                 arm64_big_sur:  "29e8f407d075874ecfe535755910e5b013bc9da62c15ddd1f095270b642336c5"
    sha256 cellar: :any,                 sonoma:         "af8ad403611fd3b45c185a537d7351a9b4538be7a161d6818d1e2326f9214fe0"
    sha256 cellar: :any,                 ventura:        "abba23b4d43a1abeb313d1efaf43ed6ad8c0b83cd8cb02891a8d1de32b395d35"
    sha256 cellar: :any,                 monterey:       "d76f4a0b6f3465f8a3b5443db5a67553ea0164350dbe1fc8a4106f4329f3ba5b"
    sha256 cellar: :any,                 big_sur:        "b1b774bb526cfbf5742ebd662c521040be27c885d1b104cd7fa41ffd3e03f511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c733c49de05ff2ebff3b768115e50b0ceed3326094c16df686b5a7f8d562e8c2"
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
