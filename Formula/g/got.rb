class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.103.tar.gz"
  sha256 "32405e93f353a54fabca5492e5a6c5425f159b7a614450909299c8dc83492878"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "10cd292dd447dd1788394a4afa33c5a799ea6d45cb5259becb5b076e624e06c8"
    sha256 arm64_sonoma:   "2d57a6e01b060cc3d615c2bba8c8defe8faafb40d753501771d2de618e1ee1f9"
    sha256 arm64_ventura:  "498038b2805604bb2319933aa665ae25bbbaee1b6ace3e408647a23a428f5875"
    sha256 arm64_monterey: "ddc3d1f88477970346a92010dd04d65a5baab84636f5bc64c8e570f168a9e743"
    sha256 sonoma:         "881158d7a46c9be26475c42127561d2b6e597854b0da28a74d2e613feabaf90c"
    sha256 ventura:        "ab0175367f95b06f483fa3e7b474ec54512241a7eb89156b5b91464d96fe05df"
    sha256 monterey:       "1e833cc4b0e71054ca4ed93956810d539868b3aa305a0d0c57fa2c5420684e05"
    sha256 x86_64_linux:   "21e2439c16f7860ace934aa1aa336063598a238db6ad8ac6504540810468f93b"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    ENV["LIBTLS_CFLAGS"] = "-I#{Formula["libretls"].opt_include}"
    ENV["LIBTLS_LIBS"] = "-L#{Formula["libretls"].opt_lib} -ltls"
    system "./configure", "--disable-silent-rules", *std_configure_args
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
