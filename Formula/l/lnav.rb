class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.13.2/lnav-0.13.2.tar.gz"
  sha256 "2b40158e36aafce780075e05419924faf8dd99d1c0d4ae25a15b00bc944f4d60"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81435ab1b41cc5b56ab2a92c5eef9fca43d824648d3425568c524288ec7f6ee3"
    sha256 cellar: :any,                 arm64_sequoia: "624271a5f081874270693d12b9e3c198c23e3fbe3b198451bdd9e9564c8360e0"
    sha256 cellar: :any,                 arm64_sonoma:  "93a90add80e6d36904eb68f9ac3e929afec7761cc574250461e9ac342cc9b20e"
    sha256 cellar: :any,                 sonoma:        "127a67c37a77feeb88a325e139e29450cb9d5716018dcfc5efcc4c3b1d7919f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e46055ab9c5a4880a8e1d8fb69abb70431b2cd603e4e060f823ffbf89885125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700d8f095d115fffc0f26201322e07cde5ad2a9027bb8542056d5289e4073874"
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
  uses_from_macos "zlib"

  def install
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
