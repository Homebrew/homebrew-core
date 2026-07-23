class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.49.13/httrack-3.49.13.tar.gz"
  sha256 "86df2478fa2b85a07b3afb43eb4efaf82d36c8443d1205d19b07c390fe810352"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "e64d81e7121bf81de6e1470dc376b19f0ba3a613586967a8a57f0524b558803d"
    sha256 arm64_sequoia: "017cbffb88547c5edcba56a1888cf64ef5e3a9749819080292b76fdb4e72b7a1"
    sha256 arm64_sonoma:  "c82ac56375535972aec3169385cb11dd492c4dc99d41b48b032cf12c228b8c32"
    sha256 sonoma:        "8d8dac8e56c5e85c4153c34382565370a151893437acf915e7c253f458fa7c2b"
    sha256 arm64_linux:   "d0fb4bf3b72c74fbc55020b6fa23e636137dfd32e49424e5be49e7c9adcbbbd9"
    sha256 x86_64_linux:  "e2c7cc8ca9504cbbf02636c384169137f187466500975419540419f063480ff0"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_r(Dir["#{share}/{applications,pixmaps}"])
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end
