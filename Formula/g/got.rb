class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.100.tar.gz"
  sha256 "fc3a8a2067ff699d3d68bfeb07bb5ef806ae1e627e98e4eb5446e4a93f565012"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "3881770918719e75e8626e9e46cca0e7105540f78c198e7978faccd532f07749"
    sha256 arm64_ventura:  "b867ea040362a6553889109c217340a1bfbeec93a6db440b6ea7064cc489ce22"
    sha256 arm64_monterey: "9930382689aded0b39db0fc9d6f9f71ad8ad39309bd521bb2198a6a69fbf4ba0"
    sha256 sonoma:         "77751a6c23f9e795f4cff7cb5fba6099d7e52fd1034af098fdac315204a217cb"
    sha256 ventura:        "518dfcd16b3661ad98b7147b539c1332ceafb28a008bf53fbbfd03fddde68ea7"
    sha256 monterey:       "6e8bbfefa729cb9319070a7b55e3df28e094ecf220da5c0b48cd757769289bc6"
    sha256 x86_64_linux:   "95befdbbbb6a30bf4e8949140a1fa623353f04b488f225afb6126a5b7ae7e510"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libressl"
  depends_on "ncurses"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@\d+(\.\d+)?}, Formula["libressl"].opt_prefix
    system "./configure", "--disable-silent-rules",
                          "--with-libtls=#{Formula["libressl"].opt_prefix}",
                          *std_configure_args
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
