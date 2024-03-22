class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/refs/tags/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ff08fb8cb3941ab320a9f4ec820da891eff3e39d14ed9c38843c573b1704340"
    sha256 cellar: :any,                 arm64_ventura:  "856d872dffdf383de68992607b02de367f2cedff332afe663a347c7cef39de35"
    sha256 cellar: :any,                 arm64_monterey: "17c55821f3fe09927bb589a1457d8ae51011ac4ee67fb4b69d4b60b61a84633e"
    sha256 cellar: :any,                 sonoma:         "12f263defc63989d44f9dbac1edc86a2e093784aae77bae5525b44c2b4d28ea6"
    sha256 cellar: :any,                 ventura:        "03c8e64ba64e0698c8def0829ff8edba107ecd8dd0b0d936458f5da9e4f7f965"
    sha256 cellar: :any,                 monterey:       "f1b40738214b734bac6ef582ce855f5743dc1ea1ca49e1e7536cb5c13df2dae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a5d1b9ee6d2a4671ad6ffbd6b8355a48f448ac2c87f53147d9293d7e9726ca"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  patch do
    url "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.patch?full_index=1"
    sha256 "7197435e9384bf93f580fab01097be549c8c8f2c54a96ba4e2ae49a5d260e297"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https://github.com/udoprog/c10t/commit/2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/f7ab02089c43dd557ef4/raw/a0ae7974e635b8ebfd02e314cfca9aa8dc95029d/c10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https://github.com/udoprog/c10t/commit/800977bb23e6b4f9da3ac850ac15dd216ece0cda.patch?full_index=1"
    sha256 "c7a37f866b42ff352bb58720ad6c672cde940e1b8ab79de4b6fa0be968b97b66"
  end

  def install
    ENV.cxx11
    inreplace "test/CMakeLists.txt", "boost_unit_test_framework", "boost_unit_test_framework-mt"
    args = std_cmake_args
    unless OS.mac?
      args += %W[
        -DCMAKE_LINK_WHAT_YOU_USE=ON
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.so.1
        -DZLIB_INCLUDE_DIR=#{Formula["zlib"].include}
      ]
    end
    system "cmake", ".", *args
    system "make"
    bin.install "c10t"
  end

  test do
    system "#{bin}/c10t", "--list-colors"
  end
end
