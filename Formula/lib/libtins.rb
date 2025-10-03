class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/refs/tags/v4.5.tar.gz"
  sha256 "6ff5fe1ada10daef8538743dccb9c9b3e19d05d028ffdc24838e62ff3fc55841"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "af8f272b96dd2249c5bdac6af064a6faa89417b4f8f176745b4017bf98bb9a67"
    sha256 cellar: :any,                 arm64_sequoia:  "5cb848c245b9b880eb92a07133a8ec40238f08cc88ab9707805368efcc4bdf9d"
    sha256 cellar: :any,                 arm64_sonoma:   "12126120e038b274429c55f65891dd2eef0bdcb96cf728de5f3fb80b863896f4"
    sha256 cellar: :any,                 arm64_ventura:  "2c1278e057086dc562909a6e748d782d269cb1969e64841daa0e260ecbdec343"
    sha256 cellar: :any,                 arm64_monterey: "fb3bcc8fe5fc54313c85eb70e579b649b6c27a73a1486fc84913188ddf8218db"
    sha256 cellar: :any,                 arm64_big_sur:  "62c5cbbc6883db588cc36570b78c38a83b730457450cc5e7dc492587af01147f"
    sha256 cellar: :any,                 sonoma:         "6910d2c7380fbd8fcf2f0b4da28409f934c29dcfe7593ccd213c2eaa3fd4b6dd"
    sha256 cellar: :any,                 ventura:        "609b84f055cac0e8c5633dae7ef910c65954ed009c1fd0d093d6b06f1a2a3661"
    sha256 cellar: :any,                 monterey:       "a474a01dc33b7daf906ae1b4fedcb5615b35892ddc12efbd497baa8a33ce7bff"
    sha256 cellar: :any,                 big_sur:        "b14d2403f2e8f6d2906df5843f6532556a3e7ebe84c558fc55ec0acea7938317"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c011d72ea5ddb35f6896b7f6862513adcedd91f632664802ec59bdc1352c62e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf78cf582a5f1411a8103f91a2c787422a790c2a821dffe949d7c97bd888888e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  def install
    args = %w[
      -DLIBTINS_BUILD_EXAMPLES=OFF
      -DLIBTINS_BUILD_TESTS=OFF
      -DLIBTINS_ENABLE_CXX11=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
