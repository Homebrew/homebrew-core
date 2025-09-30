class Never < Formula
  desc "Statically typed, embedded functional programming language"
  homepage "https://never-lang.readthedocs.io/en/latest/"
  url "https://github.com/never-lang/never/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "9ca3ea42738570f128708404e2f7aad35ef2b8b4b178d64508430c675713e41f"
  license "MIT"
  head "https://github.com/never-lang/never.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "56ada0c97c552e92c8b84dadd236772dcf5b2c6315390f32a4fe99baf0481fff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1ec72ae68f2d53ebd8a8e21e712726b4b0ed35f083e95a7752db9ef4df9d2814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de0e6c32586534fa999011920ccdcbeb91429e16a1f032e9702be8c87556fed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c74cff8a5b42c144b8936658171abc0ef544be17dd62a6552552de7f7ba781"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c676366e00825d3eab442451d7a9235af9df474e3431f775920607dddee761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe69dd034727e31b1d680ec12ab8fe6e6d6faff7c47a66f43b6ffd3d5e6e458c"
    sha256 cellar: :any_skip_relocation, sonoma:         "abbbe090dd2542052901dd60991fe207952aa1916e0fb936a4ac099140f5a565"
    sha256 cellar: :any_skip_relocation, ventura:        "9fbcc22654686fcfebff4d485b2e763bf2555672854796a9338b821bf2a998fc"
    sha256 cellar: :any_skip_relocation, monterey:       "704cf0ced4f7c9526b337dc2dfdcab520956603fbc5edb3859f042d93460b2dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "df908438891a84cc6833cf1f7d4a5e8515a9c24a787cf15a39175202c01b86f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "06ace732c395dcd140b9098c6842004a527d62dde2e6ea49974827f803847a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3732a0e925be723674dea91079efea95b0df1863dade024d110b32214707d651"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"

  def install
    ENV.append_to_cflags "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac?

    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/never"
    lib.install "build/libnev.a"
    prefix.install "include"
  end

  test do
    (testpath/"hello.nev").write <<~EOS
      func main() -> int
      {
        prints("Hello World!\\n");
        0
      }
    EOS
    assert_match "Hello World!", shell_output("#{bin}/never -f hello.nev")

    (testpath/"test.c").write <<~C
      #include "object.h"
      void test_one()
      {
        object * obj1 = object_new_float(100.0);
        object_delete(obj1);
      }
      int main(int argc, char * argv[])
      {
        test_one();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnev", "-o", "test"
    system "./test"
  end
end
