class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.49.1.tar.gz"
  sha256 "8640ab00cabc9189667cc88829620ce08ac796688f0ef94876350d14fbe7a842"

  bottle do
    sha256 "1e2501c64f53e3ccf84bbe0ac76fd28c1c986f9b8f5d4039dbd21b5f5c350725" => :sierra
    sha256 "6bfbed2441b59d7dab88d0ad168fac84269d44bea557f5953fdec0e756c49e39" => :el_capitan
    sha256 "e0a91a3b1ea93e273b5d65c143e4bab5504e0252bcec7f972f254d86acb1139f" => :yosemite
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
