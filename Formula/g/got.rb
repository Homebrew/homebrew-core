class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.95.tar.gz"
  sha256 "e689fd7dfefa380166a1a293c153348540862e2019189cedebe8c2c76372820e"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "53f1f31d78745e285d9eca3eb07badc505aa2a79cf4a418dc8c0f131f36c72cc"
    sha256 arm64_ventura:  "e49f37fb05eeb40df495c0ff68690673ee4e7a17afaa7ade733ec127616b229f"
    sha256 arm64_monterey: "451fad2821d8a03bb78327aa9b06b0a1da2f2b3cd4a6697a778380009458de60"
    sha256 sonoma:         "a3b9a6bdbfd332e91c87c6cbfabbe8fa92f73ed38461ce1705cfae9a9c810b10"
    sha256 ventura:        "6419dceba775fcca08d48f14096530a2ab2ce9049d43c555d8b4595c28aed7eb"
    sha256 monterey:       "66e35788dc80ef65b7aee2a107412aaddf18807fe2b6490b3b9a7394745e8c61"
    sha256 x86_64_linux:   "0a6762ca485fd4d48401d89a8f08d5490f7168083218057389110f80b15aee17"
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
