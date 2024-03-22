class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.97.tar.gz"
  sha256 "e07a4894a458503a32982047f064bc0c35da6349d8895be8b69064c2094e3b72"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f3a1376bea4c5c1241b459071b4d1252430de662a77d4d370994abcf69a470d7"
    sha256 arm64_ventura:  "7a73ad9745c37023250d6923a75d42e8fe8c34d2096e5c49ed6c2ec45e276627"
    sha256 arm64_monterey: "9131771ac9e8fd69ad11d397c07bc4d5c59e0944704e11b62074eab1202d195d"
    sha256 sonoma:         "a03d518b9da4c23d703a05d9850045b1be7f682087e0e90bd3e438c594f0ac7a"
    sha256 ventura:        "52365b1257ca463932c604f27aa4cb883643cbd0edb50fca8ed54384f85c00d5"
    sha256 monterey:       "0e5fc3bec6c8e0a5a2d9e37074b3ca5ffe48ffeecac684f4a14b68ddc32546cb"
    sha256 x86_64_linux:   "6d2c715f1ac2cd933a77b208d50b27ebb60ca466729c681990817a78f757ed6d"
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
