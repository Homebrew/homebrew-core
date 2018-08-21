class Dtach < Formula
  desc "Emulates the detach feature of screen"
  homepage "https://dtach.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dtach/dtach/0.9/dtach-0.9.tar.gz"
  sha256 "32e9fd6923c553c443fab4ec9c1f95d83fa47b771e6e1dafb018c567291492f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8126575ec7b9f9a4e9ba092e8d2c706c7a162c6dd7678c8dbbdc42676aae7eb6" => :mojave
    sha256 "286aa27d4de791d50bb7c16c57682174a9fbfd73890e7f58fa2681f48dc12c75" => :high_sierra
    sha256 "f69d8585d47b722bee78bc189708d5348548a3ad68a4ff6cb91443624f4a3f0c" => :sierra
    sha256 "bf26c7f68f65ae257c878e2008683d496a8c7542b3048e057bc3d588d779e16a" => :el_capitan
    sha256 "fe8735b33ebb6f2fd2ea1e7c3542981833e8cad8c16fb6d9fbb5ac0f2ce493b8" => :yosemite
    sha256 "bd984d95c0e21eda63bbb210acd381fb44e019a335ebff85a66fca89db5f11ae" => :mavericks
  end

  def install
    # Includes <config.h> instead of "config.h", so "." needs to be in the include path.
    ENV.append "CFLAGS", "-I."

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    bin.install "dtach"
    man1.install gzip("dtach.1")
  end

  test do
    system bin/"dtach", "--help"
  end
end
