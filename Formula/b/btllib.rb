class Btllib < Formula
  desc "Bioinformatics Technology Lab common code library"
  homepage "https://github.com/BirolLab/btllib"
  url "https://github.com/BirolLab/btllib/releases/download/v1.8.0/btllib-1.8.0.tar.gz"
  sha256 "c78449648f9a512ceb2bc4e95ee349bad4edd864197a63fd6d399e759018eb91"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c0362c25bef5d56648e63f8bf50456eeb46e3420a8edd4507e0e14f909f39ea0"
    sha256 cellar: :any, arm64_tahoe:       "15384b54b309de50ffdc7ff08201cc226a4be0ac53b3da42d2af487339ed8add"
    sha256 cellar: :any, arm64_sequoia:     "e91b803f0a1aaa9620df553db4aadf18603a015eb0620152ecd2c182bcf07c77"
    sha256 cellar: :any, arm64_linux:       "ba3dbf67c5756ad5ebb2e42d702a10df5cd1a33c522f38b670b76e6175094aa2"
    sha256 cellar: :any, x86_64_linux:      "4877868f7d2238b0f33db9036d4b96bde72d9c6e42e3c2c5efa54b872adf79b6"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "libomp"
  end

  # Apply FreeBSD patch to fix build with newer Clang
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/af74f60a871e4a5aa7aea787fc235a2cb760e764/devel/sdsl-lite/files/patch-include_sdsl_louds__tree.hpp"
    sha256 "84aef67058947044c40032ac39d9b6d1b8a285c581f660d565cd23aaa4beade7"
    directory "subprojects/sdsl-lite"
    type :unofficial
    resolves "https://github.com/simongog/sdsl-lite/issues/462"
  end

  deny_network_access!

  def install
    # Workaround for CMake 4 compatibility
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    args = %w[-Db_ndebug=true -Db_coverage=false]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "btllib/seq.hpp"

      #include <string>

      int main()
      {
        std::string seq = "ACGTACACTGGACTGAGTCT";
        std::string rc = "AGACTCAGTCCAGTGTACGT";
        if (btllib::get_reverse_complement(seq) != rc) {
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lbtllib", "-o", "test"
    system "./test"
  end
end
