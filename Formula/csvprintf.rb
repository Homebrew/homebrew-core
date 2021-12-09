class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.3.0.tar.gz"
  sha256 "f15737526f0505f0a26dbdd7799f7f3acc950001c64b18a5b233b8b0fd301b0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e815c7eda03c93ead3900d81e9cc6de93d9799cbcf1c6ce5d6627248c9060645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2730697c7253ae5e51b4281b43a5eb35a7bcd825b960f895632b944d7259940"
    sha256 cellar: :any_skip_relocation, monterey:       "a8288e4d1677c30e1c77c31beaaa94a69ba4901e72599aa0e495be74aaadf406"
    sha256 cellar: :any_skip_relocation, big_sur:        "582604ddedc5e609e67580e54a5da13e9d2537c21cbb17ab4e1b1b246b9fd4b1"
    sha256 cellar: :any_skip_relocation, catalina:       "5c3336fe86de8ed71ee0c14a2740a8830d3bbb6fe6db8385320eecb383ca0560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ae4b2e4e4ad33dcde1a30482c2cbe4660e96cd23fc60ea057ef31bdc2576be"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxslt"

  # Fix for missing 'u_char', remove in next version
  patch do
    url "https://github.com/archiecobbs/csvprintf/commit/c8798ed8.patch?full_index=1"
    sha256 "94142117ec45922d8f6aa001ef17421e76600f761689e096015448fd3424f301"
  end

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
