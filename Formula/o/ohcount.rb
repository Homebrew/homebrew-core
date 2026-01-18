class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksoftware/ohcount"
  url "https://github.com/blackducksoftware/ohcount/archive/refs/tags/4.0.0.tar.gz"
  sha256 "d71f69fd025f5bae58040988108f0d8d84f7204edda1247013cae555bfdae1b9"
  license "GPL-2.0-only"
  head "https://github.com/blackducksoftware/ohcount.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "9615278e57b6c482ce61401b0fedef9bdb322b7a7adb23f86c3322d1bfd18123"
    sha256 cellar: :any, arm64_sequoia: "665dfce8bf062ae58c855c9c310d4f981b85a25c44c185b524c1ecfc2783673b"
    sha256 cellar: :any, arm64_sonoma:  "baca64f4438b650363e55d0a697040696a5ad6f34ce7120ed952f0877bf52d80"
    sha256 cellar: :any, sonoma:        "a152e81df3a3a299919fddce7809d4313b3ea1fc518274dcb460cce85055ded3"
    sha256               arm64_linux:   "40730cf6a816e974616ac45b32abe5fb17b21a06b1d542274f02c44fdf3a834a"
    sha256               x86_64_linux:  "bf23b772fbaf08da94df72051a63eb74562310b9b328c56a60f47b16d2414565"
  end

  depends_on "gperf" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "ragel"

  # Apply Debian patch to port to `pcre2`
  # Issue ref: https://github.com/blackducksoftware/ohcount/issues/93
  patch do
    url "https://deb.debian.org/debian/pool/main/o/ohcount/ohcount_4.0.0-5.debian.tar.xz"
    sha256 "740228713ed4494577f9932ec13fe4be863daba9868d0bd2ac3f082c847d6a4b"
    apply "patches/build-cflags.diff",
          "patches/pcre2.patch"
  end

  def install
    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    (testpath/"test.rb").write <<~RUBY
      # comment
      puts
      puts
    RUBY
    stats = shell_output("#{bin}/ohcount -i test.rb").lines.last
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end
