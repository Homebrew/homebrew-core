class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 3

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "47b87d51941304b32356638c1fc18d7f790abc8f11d78c31cc36e3330cafaf3a"
    sha256 arm64_sequoia: "8e4b4b0b69f4f672124104df16a9cf4792d8db5209517e9e87a09cf0d2072ad6"
    sha256 arm64_sonoma:  "7c2fe232277ff3b4b6ba7891b48be012ec6b587eccb836808e5020ffff1aa0ea"
    sha256 sonoma:        "0059fb894cac54596771eea17d0841284093f8b4875f6a2ae26b8f83a646e0fa"
    sha256 arm64_linux:   "26f4637129c847fbf3a153ff0975bf4f1c38b2ca19504d53cf093349ed480b37"
    sha256 x86_64_linux:  "915770d019bb1f2d74bfd0481e6d1233bb51ab8eae2115aa070a47558edaf5e3"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
