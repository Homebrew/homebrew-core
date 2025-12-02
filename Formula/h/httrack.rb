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
    rebuild 1
    sha256 arm64_tahoe:    "6410409541dfb5b45914a08f4c18aec17fbdaa323a72e7d280787a84d7d707e4"
    sha256 arm64_sequoia:  "49d241f3883e9342da2bc7b3344f3bb4ae0e17fb2bd4f476834dbdaf3c190c6d"
    sha256 arm64_sonoma:   "38f84248540e95dd51ab69cc3ec049b03b7193e0e4b628e2d1d5ab9d9bc3e56b"
    sha256 arm64_ventura:  "82366a7496c4dad900d7c5de609becac2493bfaca4101e77b43120450ab9ff4b"
    sha256 arm64_monterey: "0345ae5cd642cad43051144018ad7716f91ba9c2a7b94f3068c5b7c855a6e8ba"
    sha256 arm64_big_sur:  "1e2db8b0a5afa31857870b780957c99975f68248c8a7e2826b4b3e9ccb1b4a64"
    sha256 sonoma:         "f0411219cf957c47ad4e80e468fb1dc758b4042b83b6ba5550022b2d12469c6e"
    sha256 ventura:        "ce79d5a831a8a5162a84e447625330038f98ea4797b5d6ad079198c5943ea654"
    sha256 monterey:       "98b7f4c73a1bb5f531bdd455942ceb00226068ec7bf5f32fd8a45b01f9cbb482"
    sha256 big_sur:        "01c1cb899db03ce18211dc2014af7f9a2592b61b32038540a8d8e5e7e40b9386"
    sha256 catalina:       "58d9d2b9cee7fd5e4d3faad7620def7aa029f81b03d92a4150b5269fc38ea963"
    sha256 arm64_linux:    "89bf73e6fa218309a7a07a8fb6ed1b6a6fd0f5c7928ef2dcea53ba97d25670ea"
    sha256 x86_64_linux:   "b7688c49793f0dab8cd4ec29ec2ac3ecb978d6f15067d0806f9bbc315bdb08f1"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

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
