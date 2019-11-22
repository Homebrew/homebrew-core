class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "https://downloads.globus.org/toolkit/gt6/stable/installers/src/globus_toolkit-6.0.1531931206.tar.gz"
  sha256 "ef7b127174016627e1e161a99a95a4558b1c47fc0d368c4c3e84320924f14081"
  revision 1

  bottle do
    sha256 "62862983a40e42adc881068a81f91279780b234d5bdc5a7ed544f0da41381050" => :catalina
    sha256 "05cb734c86b9027af8de43708a890577c057a08585721a50cf8b6a26c653274c" => :mojave
    sha256 "c768db1e3b52930b16d9b82555e8e2515510e946b62c13926c0c0ca10d033712" => :high_sierra
    sha256 "263a91ba8c35690eed22c407b31efec92d641c08405dde4432cb92ee7385ef41" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

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
