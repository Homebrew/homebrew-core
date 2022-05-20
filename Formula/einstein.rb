class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://github.com/lksj/einstein-puzzle"
  url "https://github.com/lksj/einstein-puzzle/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "46cf0806c3792b995343e46bec02426065f66421c870781475d6d365522c10fc"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40ca9b96841289d975500232b4f60c89359b68d81837231f8fa8f363e13f1c9a"
    sha256 cellar: :any,                 arm64_big_sur:  "febb782f0a81b23076ca4edc880ca0dd161b083370da8025950aff95e7f1a930"
    sha256 cellar: :any,                 monterey:       "edb114fe30d3527c77c4896310d24569188f4bed430740c2e914f9e0a340ad4f"
    sha256 cellar: :any,                 big_sur:        "80aaf55aa6e90c8122f2de289c62bc4419b9a4ec69f80bf4c3373462317aa311"
    sha256 cellar: :any,                 catalina:       "8c085442e58bea866e93f786daf3eb4910146a7234046559c5dc85a1c5b7297c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa7dcdc2fdb1ed00d35a14215d27da414e32d94818c76cc15da63a293371f06"
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(LNFLAGS) $(OBJECTS)", "$(OBJECTS) $(LNFLAGS)" unless OS.mac?
    system "make", "PREFIX=#{HOMEBREW_PREFIX}"

    bin.install "einstein"
    (pkgshare/"res").install "einstein.res"
  end
end
