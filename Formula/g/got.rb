class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.108.tar.gz"
  sha256 "6c8d320add3587ae47c06da32d41fee4087ed661931ba64dc6de77bf432bd3e2"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4b317fd1541850813b3fefa9b723827aa5c3872d84cba8e15c9f426909e702b0"
    sha256 arm64_sonoma:  "6f4e689ee764bfa52c9d1327479ccd2e8d738914fd4c9d1a147630eb1b768ce8"
    sha256 arm64_ventura: "041c1bb1a98f5ee4a5255a308926a1bd07096f9f8f3d3de5f176dda51abfd19c"
    sha256 sonoma:        "4894907eed2a19ad3ca85f431a08120494cb7cb8fb17e7cda895171f4487edac"
    sha256 ventura:       "8e087740c4353eeaf57a8e3af87dbac09a212fd70fd4796f2265064ff7e8f35b"
    sha256 x86_64_linux:  "3674927819e58479337e7b5c9c4c451496cb446b0fb0d40bc2dd9708d872dafb"
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
