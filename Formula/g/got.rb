class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.93.tar.gz"
  sha256 "c2572726bedfdc177d48482b2a23e5afba534a36918f8eeac24b48da37a920d1"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6a8a72c1351e0232f01a1a9b4609f08845b6d0847c67e4e312d4af695e72af10"
    sha256 arm64_ventura:  "6364a2546393d267fae2455d6ef0acc584e61e452705039fa0d8f8885feb0756"
    sha256 arm64_monterey: "883659434899e025022f1808b13b140045c459917e527bfd4b199997979428ca"
    sha256 arm64_big_sur:  "901b926d51e26ed588a4ec82abbc78f4cb6089530c2cafe3d46e7edbbee28a91"
    sha256 sonoma:         "0f27d4e71301ede9ff0e37eaca9932e4569383e11828499fa13fb757ab355a21"
    sha256 ventura:        "fba576d1e2c318c1f8a7e36c9fdddc4d221d96da3c84d3f3d147f67f1c04818f"
    sha256 monterey:       "7470bb0a19daf31160f9da99d0c93dfff27c16851ae85b9c775d3a219144e251"
    sha256 big_sur:        "bccb073d4ca56489d9d2075b0fead4b71c38e95f8b214a4f717d25783d78e9e8"
    sha256 x86_64_linux:   "9b4612dd7fe2d537e3653193af5de029c001ae04a08ec43ab65053f4a5248c54"
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
