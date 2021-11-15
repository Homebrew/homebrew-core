class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://web.archive.org/web/20120621005109/games.flowix.com/en/index.html"
  url "https://web.archive.org/web/20120621005109/games.flowix.com/files/einstein/einstein-2.0-src.tar.gz"
  sha256 "0f2d1c7d46d36f27a856b98cd4bbb95813970c8e803444772be7bd9bec45a548"

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

  # Fixes a cast error on compilation
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/einstein/2.0.patch"
    sha256 "c538ccb769c53aee4555ed6514c287444193290889853e1b53948a2cac7baf11"
  end

  def install
    system "make", "PREFIX=#{HOMEBREW_PREFIX}"

    bin.install "einstein"
    (pkgshare/"res").install "einstein.res"
  end
end
