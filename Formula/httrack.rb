class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.49.2.tar.gz"
  sha256 "3477a0e5568e241c63c9899accbfcdb6aadef2812fcce0173688567b4c7d4025"

  bottle do
    sha256 "8542fa3b1a4badf7290315b4174d5026c81e79c5add75432176bb5385f6a1e5e" => :mojave
    sha256 "e46c52519cd4b7caf7ff5bd034ab016362e79d4df73840305b3a54d679fa33b4" => :high_sierra
    sha256 "16e5fb0657a1cdafcfa94d9f5e1362f7f1f89e86633e371b7ad86d17b7caa37b" => :sierra
    sha256 "34e26e1534cdf1cf32f10c861833c2ab8405def4a0f2d08253acfe15e37a8b90" => :el_capitan
    sha256 "e07658fd32a00001eb85c18b159eea17e2014142e8e56c7d1e07ecbb5774be95" => :yosemite
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_predicate testpath/"raw.githubusercontent.com", :exist?
  end
end
