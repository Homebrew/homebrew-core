class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.79.tar.gz"
  sha256 "78be1c0a905184ed1cb506468359faf87e4ee86851291b1670439c46bfb3d87c"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "07addec948c746fe2558c7643aed6525ea008d1e4184e18d774a7ae8630bbd59"
    sha256 arm64_monterey: "eb9548554fb9253bee5edd5083fd52cec546d4fadc351bbbad3ad5050c7c4fb1"
    sha256 arm64_big_sur:  "e0a9f51a2498ecde602725ecf833028e13946a9de4b14ae1d0054b809e8fa8b3"
    sha256 ventura:        "b9e543596dcaa43750d10e40031d420ff19aae0b1d9f021c53374cb19e8d0405"
    sha256 monterey:       "7860aaf4e3fd7170698d998cb8a19f60bf71e40ec0cd63c1272e119c5bccbab5"
    sha256 big_sur:        "6eda1e6c39d744a1360449abf5897db2de6c7a455711808d40a4d5722897ad37"
    sha256 catalina:       "a37a24d20837eff61c15a6b047d438fe209d7110b95442ea8d531ddc64fcbc62"
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
