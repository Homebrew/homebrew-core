class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "https://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/refs/tags/20260218.tar.gz"
  sha256 "5d1bb606aae0d007e70a5258734fd43872fba950a9ccb282db4c21f1e1436e33"
  license "GPL-2.0-only"
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "92e19619a1da8b5c0e505c3cf23b2f568b4e73b91e5ec8216a0dec9f9c964f65"
    sha256 arm64_sequoia: "726bfea73e75f930ea74aed371bea7d8b37af13a27a22d2a6cae7f4680128451"
    sha256 arm64_sonoma:  "255d0d962a17c73707c7a915e392d29869e9e3922292082763cd7f2a2accdc7d"
    sha256 sonoma:        "bdebeaabc57bc79b387ac5a5a17d6c185a7f5b34655aa85497961fb9cc89e36e"
    sha256 arm64_linux:   "8292638d63fec35e0d046abbbf5c8b13bb413e2ff719b1f9e63053f512fda4e6"
    sha256 x86_64_linux:  "bf10bef174a78b2ee05f8ca4f65b80504ed93763fe33c010d0950fb3d7dac6e6"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDATAPATH=#{pkgshare}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      The shareware version of Jazz Jackrabbit has been installed.
      You can install the full version by copying the game files to:
        #{pkgshare}
    EOS
  end

  test do
    system bin/"OpenJazz", "--version"
    assert_path_exists testpath/"openjazz.log"
  end
end
