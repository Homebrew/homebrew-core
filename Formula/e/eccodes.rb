class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.48.0-Source.tar.gz"
  sha256 "62e8fa5ca137d138189a5fdd6d5b2205c89cc26338e3f4286aba3d89b49c9f9a"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e786e80c6ed8a9ca496f9abf841fc02d1a086855c508ca02a0fb056386f22ce2"
    sha256 arm64_sequoia: "4fa85c5d33e38c8e667c4d16d875f809ccbb3af0f808c1ebdc4a4bc690b3bbee"
    sha256 arm64_sonoma:  "6c99bf984310295024d1ef5f6c012a4fe56c7c68775650fe83462cbaa28d8a78"
    sha256 sonoma:        "bbf561b45aab1b39c485479824f53700a45cdf9f478a6fff9d7906ff232f935f"
    sha256 arm64_linux:   "50c47a5cbffa1448cbc0fa703d6b615c9af58ffe59b0eb1962e013bfdbbef39b"
    sha256 x86_64_linux:  "d9200d5dd37fbe1332ba9d3708fbb847774a8beb83ac8d2b731b6c1a526c308b"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  def install
    args = %w[
      -DENABLE_NETCDF=ON
      -DENABLE_FORTRAN=ON
      -DENABLE_PNG=ON
      -DENABLE_JPG=ON
      -DENABLE_JPG_LIBOPENJPEG=ON
      -DENABLE_JPG_LIBJASPER=OFF
      -DENABLE_ECCODES_THREADS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
