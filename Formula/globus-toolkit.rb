class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "https://downloads.globus.org/toolkit/gt6/stable/installers/src/globus_toolkit-6.0.1531931206.tar.gz"
  sha256 "ef7b127174016627e1e161a99a95a4558b1c47fc0d368c4c3e84320924f14081"

  bottle do
    sha256 "c9640e4f0b1829702b05fa33971fdc7dca2aa433fd1808c3ebc378b420ad3e45" => :mojave
    sha256 "577a734a0ff849eb0cbbaf4e450d9fb415d2501d2d44a1d98130e246150252af" => :high_sierra
    sha256 "4041ca27df42d80bd92076712489b5e596acc830d7b3c5071b87e2ec8510d6a8" => :sierra
    sha256 "71d60e108bb9d726fdefdecf582436c563af54ba25bf2eab11186fea6ec17b1b" => :el_capitan
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
