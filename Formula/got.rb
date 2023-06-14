class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.89.tar.gz"
  sha256 "27404932c07713400124c15e318417385411b7a1fe7ee534e48f2b9e4f096d8c"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "fddc377172ad680cc6f707cc49f70140599c53516bd201c175bd4489b2490266"
    sha256 arm64_monterey: "87d126c760d9149fc587630562d35119fe4bf7865f78e2fbc920a6d789d57cb3"
    sha256 arm64_big_sur:  "362a74de535152f0961067c6fd52ca624eae1987ae4662df621751fd04bfedf9"
    sha256 ventura:        "b9e89c415a9af989a48d3f2ed74ac01d4d94b0d78125d1e0e8320063605e2f66"
    sha256 monterey:       "70d094c0e870882442a3cd0474ac0fa0f4b39e09143e9d9210357b435d07b2a4"
    sha256 big_sur:        "2e6654b7a15973f706e6c1952b34f62c4902a4379f705fcb0d7dbd16bffc01e3"
    sha256 x86_64_linux:   "688fc4548da28085638c1bb821c94ad24c17bf9e17163c0968f7ec89e74d16b3"
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
