class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://github.com/lksj/einstein-puzzle"
  url "https://github.com/lksj/einstein-puzzle/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "46cf0806c3792b995343e46bec02426065f66421c870781475d6d365522c10fc"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4533a76cb7a6dff1c5933a8cbdab9fa5f585607bcdc3232f3a232f198c9fa0bf"
    sha256 cellar: :any,                 arm64_monterey: "7dc675b7c9292d855fd96f81fdeaeb771062598ff9d1f4ded89fac25f3b6969a"
    sha256 cellar: :any,                 arm64_big_sur:  "65bfe3364fedcced004ab52f4e4a7c74e041f1b38f2c2d34eb00a3ebb66634f7"
    sha256 cellar: :any,                 ventura:        "25348397be37286a4aa9a53a44b652f539f3899d3c12d6d8d2bbfad4e65970b3"
    sha256 cellar: :any,                 monterey:       "1a5f8115f826fb1e255c32c95da483d33e2d86624d61321dd8ca0445d8fa9a84"
    sha256 cellar: :any,                 big_sur:        "8087db8d876b79ee386200b8e5e05b8f86186d5963a117f2e3ada06a2965f812"
    sha256 cellar: :any,                 catalina:       "e4492ca4b9a3d46ba58208f65ad2747db504e4228ece85ec3efd96d7fc5e8f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5f796dbd3d7333daab032bea4a1a10cd806713a905c664afeab1bcc2863e95"
  end

  depends_on "sdl12-compat"
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
