class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "https://downloads.globus.org/toolkit/gt6/stable/installers/src/globus_toolkit-6.0.1531931206.tar.gz"
  sha256 "ef7b127174016627e1e161a99a95a4558b1c47fc0d368c4c3e84320924f14081"

  bottle do
    sha256 "5da7a2839d7c3d94c45ef69d29d33cf728689b4a7eb5be187f0acef70a17e841" => :high_sierra
    sha256 "49a4adb00b948b6723b9b2106527789324dab90dae6044a5344baed84cb0032f" => :sierra
    sha256 "b13c8904b16ac206e4fdcc45e25335ef17a636824b41a3f40766e774cbd27895" => :el_capitan
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
