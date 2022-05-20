class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  stable do
    url "https://dicom.offis.de/download/dcmtk/dcmtk366/dcmtk-3.6.6.tar.gz"
    sha256 "6859c62b290ee55677093cccfd6029c04186d91cf99c7642ae43627387f3458e"

    # Fix build for Apple Silicon.
    # Issue ref: https://support.dcmtk.org/redmine/issues/957
    # TODO: Remove in the next release along with stable block
    patch do
      url "https://git.dcmtk.org/?p=dcmtk.git;a=patch;h=5fba853b6f7c13b02bed28bd9f7d3f450e4c72bb"
      sha256 "40ca9e6f377951e2d24a509a6c95b9e572224d74d694f0d648b8b33e4d67e285"
    end
  end

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "2b707106032247e1d1832e918ec0e560b2e81af4ed0a1ee659f0803c4c172141"
    sha256 arm64_big_sur:  "b101e7090c39b48225ab0d1d895236c849b613cf1f4e9b187c7818c6e9e7b78a"
    sha256 monterey:       "abf4a42c7a34004707c70fb518e1a9fc11582e360a886a8c109b5ce6fcd6492a"
    sha256 big_sur:        "847e85cc8b29b4caaf58cf0aa001b06082f2ea83bceaf6a0b5c90abc27b1f3bb"
    sha256 catalina:       "f7872a94bd7c98fa785a61d7d9c9dd00e577002b9d563fc403f4913011457de1"
    sha256 x86_64_linux:   "bea864995df958ccf4fb449d1347b686ed28171e9417845b7a768eee2b7eab6f"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args,
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
