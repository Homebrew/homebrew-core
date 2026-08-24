class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/47/ngspice-47.tar.gz"
  sha256 "894e649651f1838a14095e5a5439e7d3aa63e87ede14d283173fda4fcdef675f"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3eab32be60e72229f3d94f6a4360ec55f2a0d7786a2b913163fb675ac7bcc7aa"
    sha256 cellar: :any, arm64_sequoia: "d69dec3cfc225c7a5e4145d2432e9ba3bb3efa2e85ac70b18a82e16ab00ce5b2"
    sha256 cellar: :any, arm64_sonoma:  "cec50e5ef2b8bc203c148e97306408ccf69b1c4c24c57e527e8af282f8637c86"
    sha256 cellar: :any, sonoma:        "967d5992ed420ab0f97b06de1a0f629d9118a8fa4d815f17a8bb442caaf43b0e"
    sha256 cellar: :any, arm64_linux:   "4c673027778ab5d6bc3ecdd5e119d9798516dae51f629655ed93419a9ac83d8d"
    sha256 cellar: :any, x86_64_linux:  "edccbf7b471e76ee35481984fd556313e976a214891db61bba35eca41193a6bc"
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
