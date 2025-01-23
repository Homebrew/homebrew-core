class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "40ba0b7fb7c9ad06d05e06b4787d743cf11be30eb4f1a03abf4a92641c5b1203"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2244b5fa7c8e7c9fad69837d8c87e21b6b934bdb35d730cd29388add2258c388"
    sha256 cellar: :any,                 arm64_sonoma:  "ae864e359da145328a10f94d4c231a86f4b199d9727d43c15699bdb2024a56a1"
    sha256 cellar: :any,                 arm64_ventura: "1cd041a8337c350c38de47ce7c2ac015a1819b2a1efb090f6563f42a729fa7fb"
    sha256 cellar: :any,                 sonoma:        "c442066258d99654dfcc78ba143cb04d5fc74ef1306a14be1d70baafba7ba6bb"
    sha256 cellar: :any,                 ventura:       "b07445d9724d1e720b4fb24983df5adbbab9fff80cc0621f97aa1429485e8dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2140c559088413340306e19ad843419a48fa5e5747269a25ed975c2945b4340"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.13"

  def python3
    which("python3.13")
  end

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{python3}
    ]

    # `lcm-lua/lualcm_lcm.c:577:9: error: ‘subscription’ may be used uninitialized`
    # See discussions in https://github.com/lcm-proj/lcm/issues/457
    ENV.append_to_cflags "-Wno-maybe-uninitialized" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;
      struct example_t {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system bin/"lcm-gen", "-c", "example_t.lcm"
    assert_predicate testpath/"exlcm_example_t.h", :exist?, "lcm-gen did not generate C header file"
    assert_predicate testpath/"exlcm_example_t.c", :exist?, "lcm-gen did not generate C source file"
    system bin/"lcm-gen", "-x", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.hpp", :exist?, "lcm-gen did not generate C++ header file"
    system bin/"lcm-gen", "-j", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate Java source file"
    system bin/"lcm-gen", "-p", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.py", :exist?, "lcm-gen did not generate Python source file"
  end
end
