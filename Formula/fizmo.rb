class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.4.tar.gz"
  sha256 "de7396ea3dabe30cd6a596da0d0d1b6432f4ea82cf31b7d8c9020cb11a42a9e9"

  bottle do
    rebuild 1
    sha256 "0a462983979882fcb8f6eb768e0d4ab9d295aab9b800f93dd46bf81ea7498257" => :sierra
    sha256 "a91b379e3b4b3ae76b504cb3f611e0426ed48bc9bdca1a395dc639a9e1c212ee" => :el_capitan
    sha256 "ce8b994c35133110109b7a17ddc07dbea594f61bb9ca55233173b810a7f23291" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :x11
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/fizmo-console", "--help"
    # Unable to test headless ncursew client
    # https://github.com/Homebrew/homebrew-games/pull/366
    # system "#{bin}/fizmo-ncursesw", "--help"
    system "#{bin}/fizmo-sdl2", "--help"
  end
end
