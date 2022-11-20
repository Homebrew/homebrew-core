class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://github.com/folkertvanheusden/multitail/archive/refs/tags/7.0.0.tar.gz"
  sha256 "23f85f417a003544be38d0367c1eab09ef90c13d007b36482cf3f8a71f9c8fc5"
  license "Apache-2.0"
  head "https://github.com/folkertvanheusden/multitail.git"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a19b4eb52cc23c3a9f3190dbdca3db1d34032bd8790a357f022f1b408dbd0cff"
    sha256 cellar: :any,                 arm64_monterey: "2d1abd3e7e31719e362d7a1f7e22375b60eb75403bab05562975dc8758b424d2"
    sha256 cellar: :any,                 arm64_big_sur:  "746bcb020d1cac7511697bb8c0a0933a3e2948544aa3069c44c79bfe7179f031"
    sha256 cellar: :any,                 ventura:        "0bd2424867668b48d47985d2679c6aa705a6d1ce8801ebad42d737828a3d11c7"
    sha256 cellar: :any,                 monterey:       "a59560fd92bc0e68010cbe215edbcb6d31cc7f57a9acd43715f7adf93bd754f2"
    sha256 cellar: :any,                 big_sur:        "4361b3a0326daff64e701bfdfcdd105d2a36003a87a9e4196ceff935beba9807"
    sha256 cellar: :any,                 catalina:       "1506d3e77bb07b8c8e6726982ce235497ba2914f872b87587a5e21b0fa3bf627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ea2a3e55053e2784688f277a659e1a977165e3616205f6706b3ec0ff8e4492"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
