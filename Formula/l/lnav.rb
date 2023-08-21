class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.11.2/lnav-0.11.2.tar.gz"
  sha256 "3aae3b0cc3dbcf877ecaf7d92bb73867f1aa8c5ad46bd30163dcd6d787c57864"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72ea556b487ece4eb5f9d2b36e671734c04c9611c82568a2339689fb774d612f"
    sha256 cellar: :any,                 arm64_monterey: "0fcbccc2ae277a0f5b021d698ffe97a2082b52f7fced94de0658dc2cd57f2e72"
    sha256 cellar: :any,                 arm64_big_sur:  "0a0992ba6d8778820f08c3868235ffc1deeb1a6b440a20ad84053c8834032ab4"
    sha256 cellar: :any,                 ventura:        "b8938d17b779daddb7323d645a3ec90c33b6bdebd6c79ad01b49164cd5e9ed47"
    sha256 cellar: :any,                 monterey:       "82e0a6cbba5b3970195a42524f8dd92e7915d5493074b0953a8269b6e17aae70"
    sha256 cellar: :any,                 big_sur:        "25aa2c49fbe0cece51da03b4b5a85d6a79ce94ff7868b4628be31f6f842dfc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e714c076b1375b6b33e37d974e85be3c52e25c089ec3d1ad79ce2966a0b964bf"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "libarchive"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "sqlite"
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    ENV.append "LDFLAGS", "-L#{Formula["libarchive"].opt_lib}"
    system "./configure", *std_configure_args,
                          "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "LDFLAGS=#{ENV.ldflags}"
    system "make", "install", "V=1"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
