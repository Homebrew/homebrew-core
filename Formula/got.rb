class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.75.1.tar.gz"
  sha256 "1a511707cf5f64f459030bd45077322821f7263e403af3121c5a1db1529ea524"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "13c8ae34e326ad2194eda583a1d26cd9c7c66f0f45de01ad09bc7201b91a57d5"
    sha256 arm64_big_sur:  "e77177ff6df73719eb475ffad8fbf6aba39882ba22d6be2347c784059bdd89b5"
    sha256 monterey:       "312377d736196669295eef3a62d1aa83fcf2cb1b60c1ad9f9f1010d3a63cd9a4"
    sha256 big_sur:        "d3650bea6d173fae553426de4bd95cb31d29286679fcb378f5c07192d435af31"
    sha256 catalina:       "ed35522a26e7241e4ed0298650293cb8a80aa0e938131fcd899760d331a497a0"
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
