class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "https://downloads.globus.org/toolkit/gt6/stable/installers/src/globus_toolkit-6.0.1517984806.tar.gz"
  sha256 "8aa4101829cd5db34b8b00cd599384d1952ad7d810b89543b2cd094120c3e87d"

  bottle do
    sha256 "be2982e801761c61955f9ac4ec7390fc860bb9049001d722dcd2feef4f35ad78" => :high_sierra
    sha256 "ea777b778a8c90f71f0e56e44a3a6e1eb4708647102ebccf983b4ed4945615c4" => :sierra
    sha256 "792897db1d326a27b8185ad49fdddbea89b6b12203a056b9f0eeb91b57bbc93f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    man.mkpath
    system "./configure", "--prefix=#{libexec}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
    bins = Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
    bin.write_exec_script bins
  end

  test do
    system "#{bin}/globusrun", "-help"
  end
end
