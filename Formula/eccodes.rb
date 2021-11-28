class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.23.0-Source.tar.gz"
  sha256 "cbdc8532537e9682f1a93ddb03440416b66906a4cc25dec3cbd73940d194bf0c"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "26f7573565db98d674108f36818dc938e2fe61340fd8ace3535acc0eb4209cde"
    sha256 arm64_big_sur:  "b16288b8e285a187f91ae6b7cec94face9fc1f28bfc888eb8e1bf50aa74a765b"
    sha256 monterey:       "7eaf6b6134b71951aa7abb351e10a1a008845e4d4df724be833c66c17d21ebd6"
    sha256 big_sur:        "b9bda6733d23098c49062f172ab721c2ccc56e37becf133c1e2d88fad17a904a"
    sha256 catalina:       "0d7e1a89a8631e9683e5303098be30a549f1369b98350d6475020e2708789f71"
    sha256 mojave:         "ec525f2dc9352dc64c33be76c8e0c6e24913caf6d7ec0302bc3e830305d6f9b9"
    sha256 x86_64_linux:   "36ade0ba4eb6d09766097abba7d2cd9d76fdf4b2a4233f782deefc265c3a142b"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
