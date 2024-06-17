class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "228e3a1e2ce20a49cb8995ea78b711eae4d01f4647834f6ec765be841d788cc3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "5a47449081d0fe08c5cb52bd38dc05e5ae93d37d57b52c0a21207f30c8b852ab"
    sha256 arm64_ventura:  "4e3a1274ca89fab631cbeae3f72b9729b31d4626d20ec92fff407a3995e8bef9"
    sha256 arm64_monterey: "98c1d6f8940af49207f7759424acf8ae101e0ae310530900d1ebf07be876971e"
    sha256 sonoma:         "5ac537b13e75edd12f58394c38e34806174d9dc602b876f26f88b1eee89a45a1"
    sha256 ventura:        "1f32bfa0cc91e09483ffbfc3412e2626cc4c64c1de8c2a2111890162e1922ef1"
    sha256 monterey:       "dfce9a8631c301b1a123ef26edc81523cf6a3309f645644ebed95baf19d33224"
    sha256 x86_64_linux:   "e4090c8eae88fb300f9f4a6e9fee8cd53f22f9dd6c4f62eb0b8c510d6f3aa2e3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
