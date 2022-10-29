class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.77.tar.gz"
  sha256 "fcef6eec48ba7f4ac6afb2d159c1bd15441ded9faaa6adbfe87d358cd4750bba"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "27a3cc02167b16ff3dda6bc55323e505f64ce41658e45c0c65d98b74daefb2a8"
    sha256 arm64_big_sur:  "f3a6b16bac06b12c4ba8d171fc6127afcb668ea307646ca923dbee03da413ddb"
    sha256 monterey:       "ccd742848ed749de1d540dd45e503235644e528bcfb7b502be0f040fa00f05fe"
    sha256 big_sur:        "63ed38d6c8c0772443f68ff924df4c9a29216e5e6946d701ba50b0ebf01fd458"
    sha256 catalina:       "86afc714031f26b7d1199510b0ed98b5e077ad29d093223e2f4a9e39d65ab98c"
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
