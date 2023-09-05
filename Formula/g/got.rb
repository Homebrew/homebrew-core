class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.92.tar.gz"
  sha256 "1da342c606e5d1ec2f23dea3afdfc1809a61aa8402e4fd9ab63e5ae756e3f7d7"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "402e11fb8f650034ad11cc42ebf5b7b2850dd8845a80f0a1468132a28cec2db5"
    sha256 arm64_monterey: "dafafbb7e1c5be06a0e496fa9e88b38872ff1736629f4fe76798552927ba7884"
    sha256 arm64_big_sur:  "9ca5212353492fa05b5e5b9163ab9ad987eccee9678fa359760e3bd1e89aaa48"
    sha256 ventura:        "b1bbac73a577e113151f37aaa0550e3089487e423eb3c176b4bc1183084a627b"
    sha256 monterey:       "78f1aad6ef2e687abee29f344d48acb52cfa55745449f3cf89964e9248710a3c"
    sha256 big_sur:        "06fb21124776df3172b5f73c39090ba155dd036137df4991a3e65bfb17b24d22"
    sha256 x86_64_linux:   "ff486843e2854b2b1356830cd2be1f495250e835d11f4f3f2a6206b0fd60ac6b"
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
