class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.14.0/lnav-0.14.0.tar.gz"
  sha256 "0fd591a2e0488a06b3b44d7b384d3d7c6852d68607efc16ef4dec7a6ed054eea"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0734c28ac29d9c1c9105f83fc8089c7a611abc3c9363f6f43d720cc2f4fe8d7c"
    sha256 cellar: :any,                 arm64_sequoia: "bde37fd78c8db1a3a69a9bb5eaa2218b75ea130bb67303e9f67eff3666123199"
    sha256 cellar: :any,                 arm64_sonoma:  "aed48c97b6665f786f5ab5691e92aff8d0be62da9bff62301fa48a39e05aab82"
    sha256 cellar: :any,                 sonoma:        "fad8a10875f7181c826994ddcb4c08d21e4d4581178060b1b24756728940ef3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "711760343dc3a37c61950a2c67ba418f6da61e9e0c9b52f6c478e186895d41c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52adf18fb91dea662e9a75b78ad5d7041efa98864d00198ea61052b131f6fc1f"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "re2c" => :build
  end

  # TODO: Make autoconf and automake build deps on head only upon next release
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "rust" => :build
  depends_on "libarchive"
  depends_on "libunistring"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
