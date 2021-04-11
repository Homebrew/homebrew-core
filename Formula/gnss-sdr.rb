class GnssSdr < Formula
  desc "Open-source software-defined GNSS receiver"
  homepage "https://gnss-sdr.org/"
  url "https://github.com/gnss-sdr/gnss-sdr/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "b1636455ce70be9cb93793ee5a68faa47d8bcdafeddbcab55669f545e6271b6d"
  license "GPL-3.0-only"
  head "https://github.com/gnss-sdr/gnss-sdr.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "gnuradio"
  depends_on "hdf5"
  depends_on "openblas"

  def install
    inreplace "src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/CMakeLists.txt" do |s|
      s.gsub!(/^set\(prefix .+\)$/, "set(prefix \"#{prefix}\")")
      s.gsub!(/^set\(libdir .+\)$/, "set(libdir \"#{lib}\")")
      s.gsub!(/^set\(includedir .+\)$/, "set(include \"#{include}}\")")
    end
    system "cmake", "-S", ".", "-B", "build", "-DBLA_VENDOR=OpenBLAS", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "gnss-sdr", "-version"
  end
end
