class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.84.1.tar.gz"
  sha256 "208305e9e6c214fb46ddd5be7205b29d65bf3dab2062d294d30c9b669b4f0157"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a632986306c399e654a27a8ebf5c1ac9e1cb707e034e8f052f43bf818d9008ec"
    sha256 arm64_monterey: "654178cc06b6306096d836ce721cafaae47e1d31623ec380fef42a75d1c992cb"
    sha256 arm64_big_sur:  "a6e8fe9ca6aab7c2eff5b2f14a0406c93da8bd749caffd314b2d50107cec6b39"
    sha256 ventura:        "758e4e7f972819ec0d2a83f1e789ce1a47736606f9690bb4b939b06c0b21a031"
    sha256 monterey:       "71c51de0103e8f4c1fa4075977092d452c9140828a0a894bbac906cd46398a97"
    sha256 big_sur:        "152693ad826b71ade82c83011cadb271d683f0f10cfd034cff1def6370abb967"
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
