class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://github.com/lksj/einstein-puzzle"
  url "https://github.com/lksj/einstein-puzzle/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "46cf0806c3792b995343e46bec02426065f66421c870781475d6d365522c10fc"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "724fc0ba32697d2b2545555909c6d906921ac9b35ba6a2ff00734a0b74213837"
    sha256 cellar: :any, arm64_big_sur:  "68cfd59e5ded3c4b91f81edf0e3b2d0c99822025b6828cc710216d5923bb49b2"
    sha256 cellar: :any, monterey:       "04c7104f132a50ba1071db74a9444dd0f5b5a8907a6794ffd9a03a0a5fb62a74"
    sha256 cellar: :any, big_sur:        "a3e0ddd14989c54fb03fe46c3f1b4ab37b8f2c882add23348041d19036d3fde3"
    sha256 cellar: :any, catalina:       "7407f84e2b5f164daba38e36654bc0254b3b9094e4e499e1346a4d94943b38de"
    sha256 cellar: :any, mojave:         "df8d532f00641727e29c50e3fc47ea52c9e8c1d1e98909922267bd71dad5d1a3"
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
