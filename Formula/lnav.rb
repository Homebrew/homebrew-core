class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.11.1/lnav-0.11.1.tar.gz"
  sha256 "7685b7b3c61c54a1318b655f78c932aca25fa0f5b20ea9b0ea6a58c7f9852cd0"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "744155bbc1e343427acdbdc2a02307f05015b0b1880742a88907b79d035893cb"
    sha256 cellar: :any,                 arm64_monterey: "364cc0e9958a7a9b1daa0899a9c4a29b67fdd117d6804f66f83bb1bd429dd971"
    sha256 cellar: :any,                 arm64_big_sur:  "97fff24ec910f9c73624d2962315cd9d69f2a4582e15ac9a36f641aa669f434a"
    sha256 cellar: :any,                 ventura:        "3064b0e3888ac5c3c32c36fed7a4712e303be92d235ca8f6a02c4742ab698e38"
    sha256 cellar: :any,                 monterey:       "0d6dadc6f2495f5199e25095bec8093e8b838077fb1b093efb12142c38d475e2"
    sha256 cellar: :any,                 big_sur:        "bd67b7bdf92a9cc99064a0ec2bf6019f0eff281712549c36503f704ccab77a1a"
    sha256 cellar: :any,                 catalina:       "9e2ec27502d164cfd2c415b673009fd280d607c27262d5136145fd59ebfdc8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50f25b4f2a477537758b91bc503306a62faffe4dac6d3b27c3cd85b3f6f9b1de"
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
