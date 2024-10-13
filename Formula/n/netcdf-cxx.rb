class NetcdfCxx < Formula
  desc "C++ libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc"
  license "NetCDF"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa65ea58fe18f5efee9cfe415cc6fe06f6c461068a679d539db66bdad48f442c"
    sha256 cellar: :any,                 arm64_sonoma:  "590fd101fb9fa4cf1a99e3472d6401dbe1b5b1119a542e7134a4d9c5f3f03db0"
    sha256 cellar: :any,                 arm64_ventura: "e3f3483e6fc0d72b6dc01db50fd73bd39ac1bf4a28b1d43e11432b623a4787e7"
    sha256 cellar: :any,                 sonoma:        "ad5b26a0c7acba00c155ec9357a37fad6712eea68ed5d6a5d87aa75e4094cd17"
    sha256 cellar: :any,                 ventura:       "bff9294786d018153888af19624377f2947fb7132d5b259f24241318bc1e6d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b51b28de46082854a8f0e614b7827e5f1d4ecd6f346503992e115e97e8cf277"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "netcdf"

  on_macos do
    depends_on "zstd"
  end

  def install
    args = std_cmake_args + %w[-DBUILD_TESTING=OFF -DNCXX_ENABLE_TESTS=OFF -DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON
                               -DENABLE_DOXYGEN=OFF]

    # https://github.com/Unidata/netcdf-cxx4/issues/151#issuecomment-2041111870
    args << "-DHDF5_C_LIBRARY_hdf5=#{Formula["hdf5"].opt_lib}"

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/cxx4/libnetcdf-cxx4.a"

    # Remove shim paths
    inreplace [bin/"ncxx4-config", lib/"libnetcdf-cxx.settings"] do |s|
      s.gsub!(Superenv.shims_path/ENV.cc, ENV.cc, audit_result: false)
      s.gsub!(Superenv.shims_path/ENV.cxx, ENV.cxx, audit_result: false)
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <netcdf>

      constexpr int nx = 6;
      constexpr int ny = 12;

      int main() {
          int dataOut[nx][ny];
          for (int i = 0; i < nx; i++) {
            for (int j = 0; j < ny; j++) {
              dataOut[i][j] = i * ny + j;
            }
          }
          netCDF::NcFile dataFile("simple_xy.nc", netCDF::NcFile::replace);
          auto xDim = dataFile.addDim("x", nx);
          auto yDim = dataFile.addDim("y", ny);
          auto data = dataFile.addVar("data", netCDF::ncInt, {xDim, yDim});
          data.putVar(dataOut);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-I#{include}", "-lnetcdf-cxx4", "-o", "test"
    system "./test"
  end
end
