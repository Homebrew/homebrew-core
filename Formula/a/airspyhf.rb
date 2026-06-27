class Airspyhf < Formula
  desc "Driver and tools for a software-defined radio"
  homepage "https://airspy.com/"
  license "BSD-3-Clause"
  head "https://github.com/airspy/airspyhf.git", branch: "master"

  stable do
    url "https://github.com/airspy/airspyhf/archive/refs/tags/1.6.8.tar.gz"
    sha256 "cd1e5ae89e09b813b096ae4a328e352c9432a582e03fd7da86760ba60efa77ab"

    # CMake 4 build patch, remove in the next release
    # PR ref: https://github.com/airspy/airspyhf/pull/54
    patch do
      url "https://github.com/airspy/airspyhf/commit/e9c483aaa6da6faebc648ba2a065608dc7f3ee08.patch?full_index=1"
      sha256 "06d76fc39f1473c7a09bef1883b68c6bf965b56a1e02c870f5c4d7ea528a78f4"
    end
    patch do
      url "https://github.com/airspy/airspyhf/commit/0aa25232542b2bccab3f94a1f7171d8720709d6d.patch?full_index=1"
      sha256 "850e7e46cc154f12c4a86254e3f8be0d7b5704bef8bb4612819838c0cc99aa86"
    end
    patch do
      url "https://github.com/airspy/airspyhf/commit/0dbb10cd22e2ef1546c8a79d418529bd577acd23.patch?full_index=1"
      sha256 "8736a181e3e6d2cf377f09df2a086ce950c9323e23b9b02dd00685519c30edcc"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1c1fd82f7cb86587bd29d675af8ea216722ed5e0aee0eca6a137afc0adda0ca2"
    sha256 cellar: :any,                 arm64_sequoia:  "56ba130afa6a1ad1fe9fbda09e0ae0bfefd6eb4d2e5b5a88fa28b150c2a4c1f6"
    sha256 cellar: :any,                 arm64_sonoma:   "b747dbc3b901d77c790fd984fdbaf37979b0e3e7ef0aaca8d616be09353fbe37"
    sha256 cellar: :any,                 arm64_ventura:  "5fbaa0afc4b557fad2a08babdbe97253a76ab494b81dbc402fe0ca9d5c26674a"
    sha256 cellar: :any,                 arm64_monterey: "eef302a163fb091b112c40684b5dcc04e226e95df03042cc9c77ff6e1b637f9c"
    sha256 cellar: :any,                 arm64_big_sur:  "687651c9d95e06436df3a43a0dca6e3d39747bbf2d92892edf44bddd964c5345"
    sha256 cellar: :any,                 sonoma:         "c6bb7ad085e41a534221d9fc96bb4f9692d6af6d49a821d973f9091dc7040615"
    sha256 cellar: :any,                 ventura:        "506b301e7f411e447bd5b0bab09551eb1ace6fdd62d76a99239e42c648cb2cb4"
    sha256 cellar: :any,                 monterey:       "4d8688285b59e46abc06d20c835e82a4a5ae3271ad469e12f5c249e464419a31"
    sha256 cellar: :any,                 big_sur:        "e41261aeca3a632c9c2cb265e321fe2ff88820901ea1d3ea01e42e2a1ba0413a"
    sha256 cellar: :any,                 catalina:       "d8b783edf8b206ba8228c96bde21a0dfb42771bc5c46e3493f3dd995a0dfe4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e84516121578b8b4e3ed09e2617fe1fe378e7267dd900d8ab08c5cea0de963ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d30b5b22a4dc96558528d46a73cdb6102b49601f9fe04abfc3f9c812606600"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libairspyhf/airspyhf.h>

      int main() {
        uint64_t serials[256];
        int n = airspyhf_list_devices(serials, 256);

        if (n == 0){
          return 0;
        }

        return 1;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lairspyhf", "-lm"
    system "./test"
    assert_match version.to_s, shell_output("#{bin}/airspyhf_lib_version").chomp
  end
end
