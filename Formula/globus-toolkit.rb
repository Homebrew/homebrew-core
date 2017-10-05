class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "https://downloads.globus.org/toolkit/gt6/stable/installers/src/globus_toolkit-6.0.1506371041.tar.gz"
  sha256 "77911b143a0bee937ecd7ca9d5c646c0d0bf82756bbe5e831bf281d05c0e7bb9"

  bottle do
    sha256 "919e6d3c7664dc0ba6745b3121aec2e9ca40c4097f526b6c026cdb916dcbedac" => :sierra
    sha256 "fc8f89ee1a07796f846360b5559b3515f2e6f8a9278c6a801176e324d3f2fae2" => :el_capitan
    sha256 "2bdfe7e4d4479ade4f764f6ad9373904a21df72fc8d9e18713d9442c39ecb704" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
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
