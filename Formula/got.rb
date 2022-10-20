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
    sha256 arm64_monterey: "35dba646a672c747d8ae4d994361507ff7cc45543f6cf6afe6044dab83ee96a8"
    sha256 arm64_big_sur:  "f444d72268aa821d2d79b10e435bbb2cf9ba724b93a92376118cd1ad083cfc9d"
    sha256 monterey:       "72fd71b7129d6d1d9d49928968e87800e1ed909da7aade7f8a7e42db15e1c7f4"
    sha256 big_sur:        "29179856dc8dfe305cb8a17bee13fda5b366387c6c79f99275c146ccf8e5ddf4"
    sha256 catalina:       "5b1251dbd1203376a237edd4465d16f4903ede332ab6a5817d594464841b63a9"
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
