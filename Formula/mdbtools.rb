class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v1.0.0/mdbtools-1.0.0.tar.gz"
  sha256 "3446e1d71abdeb98d41e252777e67e1909b186496fda59f98f67032f7fbcd955"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd5023a5419a776cefa3e4bcd408536a696459f1fd3084822e22565e3cd75c39"
    sha256 cellar: :any,                 arm64_monterey: "c4502a9b481c4e40f0bc5c1767af43938cea64ea125a564dd1371e0cdad5729c"
    sha256 cellar: :any,                 arm64_big_sur:  "1f808f4f3574633bb4d3176046a4b98dd0f673291db20ef5f34357f8e04aa3f1"
    sha256 cellar: :any,                 ventura:        "f4bf3ad76af45f61c2d29418a66c2ec3ae61bf34cd02bec78e84195653ace158"
    sha256 cellar: :any,                 monterey:       "b11d8015632397cfcc11ce21225d3f5d5001bcf64f55996c20713ac9ddc48c46"
    sha256 cellar: :any,                 big_sur:        "705cecb093ad9dc51806e241b75389a4843b2ea57170a5653aa15face44323ba"
    sha256 cellar: :any,                 catalina:       "472f8d9eb6f9608ef300715e1e7774625643c5433dfef4844eb8337c00a1cdfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941c3eae4065118abd7bf72a1a42da8c33d7d1c706f655622254a8989e4e0468"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-man"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
