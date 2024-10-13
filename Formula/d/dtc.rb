class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
  url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.7.1.tar.xz"
  sha256 "398098bac205022b39d3dce5982b98c57f1023f3721a53ebcbb782be4cf7885e"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://git.kernel.org/pub/scm/utils/dtc/dtc.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f29a70e4bd3164a430701c5432fe44b372be1be0518e1899fc729bbb7a188e5f"
    sha256 cellar: :any,                 arm64_sonoma:   "eb7120f37159256116e64121d375138261b8c72ffe81ef7291a3857d0360b732"
    sha256 cellar: :any,                 arm64_ventura:  "9416a7697631acefd2250e195b4d5ce86869edd2748bf9410caa9fe81b93cd38"
    sha256 cellar: :any,                 arm64_monterey: "4e0f9913316c81c08a81fa2a19e5894f96d423dae10ba0aef3f91575d6b6a919"
    sha256 cellar: :any,                 sonoma:         "22883f387048656f036c886b165f7091caad013cc124380dbdb069da4b53e868"
    sha256 cellar: :any,                 ventura:        "299d6048d7cf4f916f32c11bf1eb9ef4c0d48213f76080ee9ac2abb42112a049"
    sha256 cellar: :any,                 monterey:       "c357239b7a902f9d8233eb2bab55cecc6c44e4cffb01961e4335bbfd260cf904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa403b6f99b65c894707c311af4e5ca1c4defa454543aaed245e229a38a0217c"
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
    system bin/"dtc", "test.dts"
  end
end
