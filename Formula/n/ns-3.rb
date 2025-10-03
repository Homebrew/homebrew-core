class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.46/ns-3-dev-ns-3.46.tar.gz"
  sha256 "284c77fda5f48b43808fa218eb9ecc4c303a3a77a7b5bf89e3de5d82cef880c8"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_tahoe:   "7e1c4ae53154eb0c4d19dd4b38470727cfe69b75eb5b64fd4b81b96e0f95afaf"
    sha256                               arm64_sequoia: "b82a111ac2af1a20221bf78d88ce60f84e75c8269ab91d13bf8662d9a405eed0"
    sha256                               arm64_sonoma:  "ce9fe7fcea0f60ad6c1c67b8ddcc41a54ee80048bf25a80af83f629c632e3595"
    sha256                               sonoma:        "ad49a316a753cf240d6b236eb870d506c96d175bf1cd706d5d12a31ceac527d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d6d2e71bd75d9977aa9cde1c91c2fc0aaac6809b539f3ff952c907993d493f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6de224113cbfc085d1983108919af9296bb860020dabb67bcf65636a4f7247c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    # Fix to error: no matching function for call to ‘find...’
    # Issue ref: https://gitlab.com/nsnam/ns-3-dev/-/issues/1264
    inreplace "src/core/model/test.cc", "#include <vector>", "#include <vector>\n#include <algorithm>"

    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]

    args = %W[
      -DNS3_GTK3=OFF
      -DNS3_PYTHON_BINDINGS=OFF
      -DNS3_MPI=ON
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/tutorial/first.cc"
  end

  test do
    system ENV.cxx, "-std=c++20", "-o", "test", pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications"
    system "./test"
  end
end
