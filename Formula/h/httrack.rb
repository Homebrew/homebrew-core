class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.49.2.tar.gz"
  sha256 "3477a0e5568e241c63c9899accbfcdb6aadef2812fcce0173688567b4c7d4025"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 2

  livecheck do
    url "https://mirror.httrack.com/historical/"
    regex(/href=.*?httrack[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 arm64_tahoe:   "b32f52b8a3d7c29bc4ef8786a5d7442b989d007c92ed205bd8e2fce3d7d9e7c3"
    sha256 arm64_sequoia: "c490f41b189c3f0627d2430c16657c2789ef61fe533d90ed72ab5c5e0869fd9e"
    sha256 arm64_sonoma:  "896935f765df6afd7676c0b3e582ae66ce4052a097b20e78200aadef15be4268"
    sha256 sonoma:        "58af4297d8cdebb0c20de947610b3f473f5081ac81fbd75a253c27c570362c2c"
    sha256 arm64_linux:   "548edf68271f1856edf0f9c34153043ece5575d8b97f1e3373cbabde82f93cff"
    sha256 x86_64_linux:  "4425d23c7e0fc3fbae36a0201b1519e4fb2ad3f6789caa4cf1b58b43e8c826cc"
  end

  depends_on "openssl@4"

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
