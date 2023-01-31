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
    sha256 arm64_ventura:  "04bc06ba2f818177581218884b24a545d10ebd7e81a949a57430f3c1a5607dda"
    sha256 arm64_monterey: "1f0d80dadf382dd8cd9fee1fcf0bc896f4f2d23e9d663e4e805f5e514dacd614"
    sha256 arm64_big_sur:  "6e61574ed4938127c7c634553b99ac1655a132ad1feb854ebc795f61c6a563ae"
    sha256 ventura:        "4d24d2e7dafaa59b6a74fe46bd408494c76ebc13fc5b47189d32082615226649"
    sha256 monterey:       "8055b74996a41249462da767408e7171f12959f7fc2653f1277bcde3d513dcc6"
    sha256 big_sur:        "5cc18c68e3370d60c767e699d804b423c18430b1b70ba9662e361eb65809b1a6"
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
