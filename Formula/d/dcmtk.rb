class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dcmtk.org/en/dcmtk/", browsed: "2026-08-06"
  url "https://github.com/DCMTK/dcmtk/archive/refs/tags/DCMTK-3.7.0.tar.gz"
  sha256 "5bb3ec8317dc465788bed2ca789e76d03ae5848c9381cce3b14c1a3f8b6aca56"
  license "BSD-3-Clause"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url :head
    regex(/^dcmtk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "18fdc9d620a8913c66d703dd279c659cfcdf0a0b599d364e545f4513d6578980"
    sha256 arm64_sequoia: "036013db99c711b150a93a7d5f870bf21c6826cb8e4150dd2539954859d397c0"
    sha256 arm64_sonoma:  "42e407ceb5de1da6bf2b283ff0d540421d9924c0939cbbb585da272dbc5f4162"
    sha256 sonoma:        "4646deaa5d70c8d92620faad87006086369be8fe614eb71c30e39b5604557b46"
    sha256 arm64_linux:   "254bb8fa063e79ddcf1800481b89d9dc6c6ee02298981a365cbda4bd144dce32"
    sha256 x86_64_linux:  "773d92006e42ea21daecb8138174f768d13050ac78cf32b2ba27f7895f396557"
  end

  depends_on "cmake" => :build

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
