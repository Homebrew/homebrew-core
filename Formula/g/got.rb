class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.91.tar.gz"
  sha256 "79b15eb508601018f2ddaab74df2bdbde79ebdb992004bfd91a52886c9ecae55"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a9555343ba0ced9553c44c72012594273fb16f8dbf83bc54fafedb09ca0c4a10"
    sha256 arm64_monterey: "5db0e3e095379a73eacd589e067013dbe3e1bf726890f40ef2f12daa58f3b058"
    sha256 arm64_big_sur:  "f497aa58dc335d51eda8c5a29d1cd49f2bae45706dbd8c8a2d1551acec212898"
    sha256 ventura:        "3dc0404cdc98baa15b1533834834148a8244d7fbdc3a358b2558500921c98646"
    sha256 monterey:       "9f59bb1ceefe272e82ff76d13be1433f7925fed10adf7603fb2ea93af2c4ca6c"
    sha256 big_sur:        "856db5869b1ee260f0f98900851893054a9cadf2891043bc772515fbaf5242c9"
    sha256 x86_64_linux:   "6d592f5def000b6f27f1c727768843f094ea33d6c0fddcee7d19a62c4f5a482e"
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
