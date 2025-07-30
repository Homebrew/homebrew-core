class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.116.tar.gz", using: :homebrew_curl
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.116.tar.gz"
  sha256 "e8a64ad73b82c1b6df9df9da5a3e8da9be6051c3497379940806878d958e4dff"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "de57fc967046ef9aa8fcc1581fe067be0a6ec7b895440b0f667fd783fa0b00d0"
    sha256 arm64_sonoma:  "9b069ff44e0c2074c2f5d76721be9e79372a44a00a224af6e5ee65cb35adb966"
    sha256 arm64_ventura: "43be5204391ef038514cb4b9f9487f702682684c6a2a279a907f1117c03664a0"
    sha256 sonoma:        "bdb0a4a82ab4ca5f0c8f460c3455faeedad98ce47881d48c0697521fd95d17fe"
    sha256 ventura:       "d70ca44d45431f178f2c819f47c4a4e742b298fb4fa13edf08137c069b78ac3b"
    sha256 arm64_linux:   "cae4c358d8561930c546d80735c9d66cfdba7e4ba10df83ff7f0c97f3ec2a53c"
    sha256 x86_64_linux:  "8ba714da3bc588f0955fca0d6eb21b12b24ac92ebaacc12ac6da76b56e68fe68"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
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
