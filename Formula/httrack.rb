class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.49.1.tar.gz"
  sha256 "8640ab00cabc9189667cc88829620ce08ac796688f0ef94876350d14fbe7a842"

  bottle do
    sha256 "ba9cf6805554dd97a5873ea8a4e088af85ceeebe9343153933d75e6a248336d9" => :sierra
    sha256 "99bf4887538b6d195d7cbe6d36ef433876179ab28c2d446abae58855fd88ee06" => :el_capitan
    sha256 "1e1dca3f4c671f5dea037645a14691bc5bc46f2af9ad40b46050942fabb9c036" => :yosemite
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
    assert File.exist?("raw.githubusercontent.com")
  end
end
