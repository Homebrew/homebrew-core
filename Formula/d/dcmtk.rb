class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dcmtk.org/en/dcmtk/", browsed: "2026-08-06"
  url "https://github.com/DCMTK/dcmtk/archive/refs/tags/DCMTK-3.7.1.tar.gz"
  sha256 "38ac8fceebe201921f6c101493e9611ba12fb5c597db7311df26e95d6d6bf39a"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url :head
    regex(/^dcmtk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "cd6399a121a4089fbbec6b09cf0bd99dbf3ef6e68650732a1e0b306676523a26"
    sha256 arm64_tahoe:       "bf23acc9a0d33a5d1ea5c1b2a6da8ef3ef49b6cbdd5f2ec543ff91dbbfc40a6b"
    sha256 arm64_sequoia:     "fad8788faceae37a90e72404877ffabf975024094c3bea61b12d7e969747489d"
    sha256 arm64_linux:       "497449549b7c72e04cd36157b4fcb0628d0e25086e48e72ee8efa3b5d3442629"
    sha256 x86_64_linux:      "4727ccad2f5ea0e2747dfbd138e54415c0ed1fca597a3eaa13e8873197afd07c"
  end

  depends_on "cmake" => :build

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@4"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = std_cmake_args + ["-DDCMTK_WITH_ICU=OFF"]

    system "cmake", "-S", ".", "-B", "build/shared", *args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/*.a"]

    inreplace lib/"cmake/dcmtk/DCMTKConfig.cmake", "#{Superenv.shims_path}/", ""
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
