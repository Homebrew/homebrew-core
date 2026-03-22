class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
  url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.7.2.tar.xz"
  sha256 "92d8ca769805ae1f176204230438fe52808f4e1c7944053c9eec0e649b237539"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://git.kernel.org/pub/scm/utils/dtc/dtc.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e651c82ed69b6efd392728727fe0a9d4831cbcd1decca9b6a17bf307e44d81cb"
    sha256 cellar: :any,                 arm64_sequoia: "4b99efbc9d6522d1237038a22fc3417fa282d979e94db58a783a4b0ef934a9bb"
    sha256 cellar: :any,                 arm64_sonoma:  "20ee0f26c62898f07838b78489cad21b358d329f1dd3fa57bd63916e479db084"
    sha256 cellar: :any,                 arm64_ventura: "0bc0e5c7f5681e49a92833da2abecfbd10d11d7c938cab0c668df1aedec703da"
    sha256 cellar: :any,                 sonoma:        "e4eb4991109e9112f5edb62b92cec046239268ecedf2de275e21c9be7302016b"
    sha256 cellar: :any,                 ventura:       "e3702ff36779cb65af9bf30d5ae6be3bf2a03320567edbf0821251abc66c4113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5cc69857d826ebc8b792e60d7fbc695785443f5a03bff22cd6a80d96953e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73d1c865cba2244acd9bb059eae7fa4377506b64438ce12608f8f87d01e6640"
  end

  depends_on "pkgconf" => :build

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
