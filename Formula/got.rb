class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.76.tar.gz"
  sha256 "d3955420752a5e7112e029a0a29cd0d8b434ba57527dfb0617913179d10efb20"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9640150bdbdefb3bfc59ff7d40feb0e052b15babc635849f9033858e10bcae72"
    sha256 arm64_big_sur:  "fa01024e3d2dce9e3cdf795f2b1c35dc230824e57b1143d657347ef68e0af897"
    sha256 monterey:       "fd0a05acd67321140e1f09e71c623183eef553805b199517d6b15b39779cd07f"
    sha256 big_sur:        "bc7dbd2f0aa44f4abc74ded2cbbfdf818417c7ebd7b916e547afab82f925b05f"
    sha256 catalina:       "5030e68b85ee3390dd2a45be10d0d59cc8ccc1f53d4636c72a7cf9203bf04c4b"
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
