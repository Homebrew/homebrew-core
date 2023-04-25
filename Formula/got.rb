class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.87.tar.gz"
  sha256 "7c6f148a13570b17348f4d48980008dcdd1588daddf609d352144ab3b225e51e"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5fe7072b91c4f2350e97a9c050684530e5b58d98ce4145601ba12ab5289c6806"
    sha256 arm64_monterey: "23f00eb09c6687fd4c84f758b3a08fe04c91a2b4303a5ad9e8ee603facf80898"
    sha256 arm64_big_sur:  "52a26b025c0838152eaaa33b9c6c78fa151b6b2da175bdc89936adc1a2076513"
    sha256 ventura:        "f47872fd31f21367bcb4494b8267078c01bddcaf7b2a37d30f836c9b2c934ce1"
    sha256 monterey:       "155ddce2a6dd7a77dcec8a0ed3b66cf0c889dde437bad4b5929aaf8d47a96156"
    sha256 big_sur:        "fc352227830dab09539449e6e8ff2b5532e3e9ae1cc5a18d27f7d2fba8de8a2c"
    sha256 x86_64_linux:   "f23f47f085e7b95860b661f07cfb204ec35356e8de2b31358b29e3ca6fa4aa39"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
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
