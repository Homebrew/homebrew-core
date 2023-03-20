class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.7.0.tar.xz"
  sha256 "29edce3d302a15563d8663198bbc398c5a0554765c83830d0d4c0409d21a16c4"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://git.kernel.org/pub/scm/utils/dtc/dtc.git", branch: "main"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ca326b92b46108692e2f27bf20e83877bf772650f0e6912be5ce3934df284a5"
    sha256 cellar: :any,                 arm64_monterey: "c156365bf2807a0752ee136419436ab12158e10e302ba33074f7a339f35b8023"
    sha256 cellar: :any,                 arm64_big_sur:  "12e2e120158a5aff71fbf0aa51f4b56634d57458182b9fc3f03f960f8051e49c"
    sha256 cellar: :any,                 ventura:        "2272219303c0ed39def742cfbccfccf2c36f5d17387db9b6a49121d7c2aafef9"
    sha256 cellar: :any,                 monterey:       "a319159e5002540c731072ab606432bfb116e2dc6606a3086be1b76c7bee0f68"
    sha256 cellar: :any,                 big_sur:        "a30c0c5fa40f7786a727e4a0075cf76c4ec44564844c7730f2a594d83fbf2fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "383124731672d1c9ac6b80a024f5d2351a4661c9923b67d0c2aaae165f683422"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    inreplace "libfdt/Makefile.libfdt", "libfdt.$(SHAREDLIB_EXT).1", "libfdt.1.$(SHAREDLIB_EXT)" if OS.mac?
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    (testpath/"test.dts").write <<~EOS
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
