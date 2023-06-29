class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.90.tar.gz"
  sha256 "da353f43a5b91b563f1d9be4b2bdb50fddfffc70b0a4b777fa5dd114629bf783"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b9b6ec876b20776d9c8c437660113e0653899010d1d16017044a32b218fcc060"
    sha256 arm64_monterey: "46abc474cb145f2958e10527a9b74384d0052f2090f93532fad28c38aa4aff3c"
    sha256 arm64_big_sur:  "d180ab45a0142c75d58cf080b0f4c4b527bbb2c3046d8e2e9561b880f1dcdb60"
    sha256 ventura:        "2df4adadb5a45e2999fb2277109c4d19c74be7f6ace48c19253c7ffd5b4fa8ac"
    sha256 monterey:       "8fa91f9548a6dd74a8f1da206e63284110e445011b2c73128e1b036badcc18e1"
    sha256 big_sur:        "c9395c0881d71e9220cb44225fced53b24ae6ce22a92ef350dbda9927dc83798"
    sha256 x86_64_linux:   "5f0d2300fbb31f14df82eed504c6d32c0f86d299af0458dc2e929570a0e68e0f"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@\d+(\.\d+)?}, Formula["openssl@3"].opt_prefix
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end
