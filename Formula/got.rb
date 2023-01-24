class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.82.tar.gz"
  sha256 "2dbd16678813b86fc60409c487d7dffcad1c8b08c35f772612122d33227f9662"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c0ffbbf3def98a33a944079e67e7c5403c5f22175aab19930f64131600484ace"
    sha256 arm64_monterey: "dfe19ec818c5e815a24dd4be7370ce5c3bfd6f24a11c36189ff1a92b6319782e"
    sha256 arm64_big_sur:  "5004d6ee98cbbb95eda37ee4eec7f30b1e065b80f569964920ee1ad11a57da40"
    sha256 ventura:        "5c04081891601af07e1ef228bfc63dddea55b7d7104f3cbcfdc0942be8deb1db"
    sha256 monterey:       "35580b3ad78d0d31f0836ba0f5272c1c1c44efb9e7f28da2c362040e4a8d46e1"
    sha256 big_sur:        "8e7ea67a1005ff9fcf12f73d016570081da35a4e33c5de3b2f507c9ab11be278"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on :macos # FIXME: build fails on Linux.
  depends_on "ncurses"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    # The `configure` script hardcodes our `openssl@3`, but we can't use it due to `libevent`.
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@3}, Formula["openssl@1.1"].opt_prefix
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
