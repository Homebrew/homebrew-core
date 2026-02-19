class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.49.2.tar.gz"
  sha256 "3477a0e5568e241c63c9899accbfcdb6aadef2812fcce0173688567b4c7d4025"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://mirror.httrack.com/historical/"
    regex(/href=.*?httrack[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "9b8bc548b4e0708efd7b6f777f8b6b846d8322c1ba96266f435ac88b376a858d"
    sha256 arm64_sequoia: "59e6bfe01422fe49d1e1bca05c5074a243e53c99bee036b2fce99b8497860b8a"
    sha256 arm64_sonoma:  "95a7011456d25c7d3bb2c2c1fbf2f2ef07798168e57ebac55f0e935a71210918"
    sha256 sonoma:        "5b17229775834bfbeccbf828c4f502ee76c4158e5362226a885c8b32c7a5136f"
    sha256 arm64_linux:   "5ab4f3d92a85acb8991909cae49edcfa1381941d92708632d871afda9e154c90"
    sha256 x86_64_linux:  "8d0665d92f867729256ebc7c6877e4fabe66d99aa2dcbff3f6cb4c3160f419d7"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
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
