class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.2",
      revision: "83c1f6b1a2f45a825e9d5764b9a6d33c907c4bad"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e5b410d72760bbf997debcd9ff9927dff69fddbe1b8ea12c6ff550c9e41ad7a"
    sha256 cellar: :any, arm64_sequoia: "80745139c8802719f3eefd46bdf97995ed974033ddedcdae5cfa55d539da0eec"
    sha256 cellar: :any, arm64_sonoma:  "77aaf584fd0bc1bd4301524e1e27c8d76f4a046fac3062e035703ce753e35c11"
    sha256 cellar: :any, arm64_ventura: "3d55b37b1e59a0416e9f381356bf2913e637e53f0a9b52f393bb3e2ec8c683c4"
    sha256 cellar: :any, sonoma:        "09e2d4681dd402d6ffb1910f18f4c3e39c7c9f0acc1d9bdd94784fdc835cf39f"
    sha256 cellar: :any, ventura:       "c37cb04238f5f98a5d9a9409f8ca6e96cd0300f8d57125c0b9a8790073ce5ebd"
    sha256               arm64_linux:   "20b9a20ca6c577346a6b53b69d39de3a9504a65ec229f0e0c119115fdec735bd"
    sha256               x86_64_linux:  "2010bf71fb4caffe99888c36e54c9ff1169399226d9ddfb4b3ec6505c730ddb4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkgconf"].bin}/pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
