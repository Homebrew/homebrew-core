class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v4.2.2/mapnik-v4.2.2.tar.bz2"
  sha256 "a530f03c2bcf1ea8f9e500a0dab7f8387f1a1eae3040a886c1547b3af86f5911"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "efabe8976d1aeae07d302ab8ddfac459b96c1ec0e1f5ab9b086165977bc8cbdc"
    sha256                               arm64_sequoia: "6f4b11b2a78d683667c26ea5fd823c4e62f9f2ddb0ed2f6e8b62b3e07750142a"
    sha256                               arm64_sonoma:  "57fa1ae0c46fbab2f7c1adaf969b250907585479f922f413e6106b7d11ae7b3b"
    sha256 cellar: :any,                 sonoma:        "86a9f05bc754a8621717fd05ec2a98113079b8a4462b87e1b5bc6f71dc05c7c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1b4c53c36b1caa9578f23efea6203105b564c885f63859bf9248e1f2a04f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d6bd1b396b521158edfe8f53f86ffaf47878aa1b9e972fa862e9aab1caf306"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "protozero"
  depends_on "sqlite"
  depends_on "webp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath};#{rpath(source: lib/"mapnik/input")}
      -DUSE_EXTERNAL_MAPBOX_PROTOZERO=ON
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
