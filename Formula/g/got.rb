class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.97.tar.gz"
  sha256 "e07a4894a458503a32982047f064bc0c35da6349d8895be8b69064c2094e3b72"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e1b6ee4e3c8ace090083787a0b9d63ce83d79fc994e1d290c22e38cc9079655a"
    sha256 arm64_ventura:  "21a61b14a11fd395c8db4229e6e1a117021f74f9d15d3bd6a2d9ab85800bd905"
    sha256 arm64_monterey: "ff5da7fbd8d850ede0edb9f9af7872b5a6979370341dba1b4d6545e427f0fa67"
    sha256 sonoma:         "39ed0c187c1b77300a7feb26ca139558cefdf9b02d658a8d032e88f924f924a1"
    sha256 ventura:        "2665572d5bcc96d623a419a0dc1d41cda5ed6e399ba097a2fed8b0c61194e47a"
    sha256 monterey:       "7d8c86c32f7c749f51a5f1f60c59ba9475e310c1682e38add8567c81e8db8ab8"
    sha256 x86_64_linux:   "73e0a22678a8570fe813f006f20f8fb86b135279207487e0fe9c072677b2223e"
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
