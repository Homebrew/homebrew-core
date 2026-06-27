class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/46/ngspice-46.tar.gz"
  sha256 "a0d1699af1940b06649276dcd6ff5a566c8c0cad01b2f7b5e99dedbb4d64c19b"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00500b457ce45937b6ed298e71f282e31b88a58f6082940601ac4e1e209228b2"
    sha256 cellar: :any,                 arm64_sequoia: "e1072848e25406c31fa5bb52ca1779c1ca4b256688c9dd6ce2625fb59e7c03a4"
    sha256 cellar: :any,                 arm64_sonoma:  "a5822141038096046b13ddb18c8a2c6badd0e765f21374198b6b5a3980c3da37"
    sha256 cellar: :any,                 sonoma:        "5369ab3a5cea69eefebac3568fcded61d1da1508db5d2748903bf4a23bdd5436"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c9b5419a1c2e220a96e88fd71a4e80937cd6a66647b2f4151ee9597ad81e11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f906342f487dc58e1d53652767a14e6d00181af13096446c4e09a19ed32f24f"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %w[
      --with-ngshared
      --enable-cider
      --disable-openmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # remove script files
    rm_r(Dir[share/"ngspice/scripts"])
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end
