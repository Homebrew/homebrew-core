class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.88.tar.gz"
  sha256 "17c10730a010abf7d5fe2ebe55fe3686656385ba6dbae88ef337c4f647f3cea0"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e7ed55f5847e81c4c63663c01b97ad76c4a13133fe06f5c93f38536863d646f7"
    sha256 arm64_monterey: "bb7b1567d4465fe7703bb0f80dcf8dddb69d46991bcbbaecda7aa78e9b51e96c"
    sha256 arm64_big_sur:  "af6e45bf5589c8b633e75f65cab93f2fefd3094767a1ff67bf140ab62ba01c48"
    sha256 ventura:        "645198374956096b23356a95581462001e24e2e238d82710a075181ba2a0296c"
    sha256 monterey:       "11d7efa1f34a9ab2114ed5f061b5c90d9d88007b714611c2bb1c7761d8e86fbf"
    sha256 big_sur:        "cbca1f089b35c5cd41d09b88c098e0e214f8da55b39b87299b404058c794c440"
    sha256 x86_64_linux:   "c43548614ea6fd89b1e42afe5016fca1a3506da178a46f197594f64ab3d4c0d5"
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
