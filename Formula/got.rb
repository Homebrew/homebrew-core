class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.83.tar.gz"
  sha256 "90d854e8e47d21434f2fbd83f749e1ab65f9be6556ed8526a67abf10e52f1bff"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "128ea43fd4f312a9c5a85416c5c83c9a0aabffd2a78f208c77c3c10dd479bf8e"
    sha256 arm64_monterey: "452a369c1ff13b9700ba0d69672089cc9b0c9694710a47a4564ae24ad048023a"
    sha256 arm64_big_sur:  "d58a1ee53ebac1db929aae66c339df27b917ddb280d6fc30f3bdbafb7ad9eefa"
    sha256 ventura:        "2997774668453393867c301810ca98912a5bf28df65dbf24a7ecef1bf095da0d"
    sha256 monterey:       "9c941a28efdae2a4dd055565487c7df2183e2d6712bcc4d9311d98bdc5c5cd87"
    sha256 big_sur:        "7f8d8fc172f498ebbbb6b8a44eacdfe4b6bba5cb65ad26d22c6403da6d2759d6"
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
