class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk370/dcmtk-3.7.0.tar.gz"
  sha256 "f103df876040a4f904f01d2464f7868b4feb659d8cd3f46a5f1f61aa440be415"
  license "BSD-3-Clause"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/en/dcmtk/dcmtk-software-development/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "80f6e44fb3e6dd46f337914ea9e7c1eb12c522a868580c3f7c8d789a6fd5f4d7"
    sha256 arm64_sequoia: "825dcc58eea3bd0c629460c18f331bbaef9163bcb5c9b75434cb0cbf641f7f99"
    sha256 arm64_sonoma:  "7953dc6a8e0f468f1623883a7ba98251ff9a0482894055a9de8439e319d2edf7"
    sha256 sonoma:        "55857b197ee7c3a2f792ab33d4345832dcf5e01dada44fad42915f4069b74e0f"
    sha256 arm64_linux:   "0d04e4b45322f9c5224d5568c4a505ee6f7a32eb5c54742ac153537e8c9fd890"
    sha256 x86_64_linux:  "c0a3a5c1a1fc3f452c4e2505a61486d886475b800417b6368689186b55311ad2"
  end

  depends_on "cmake" => :build

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
