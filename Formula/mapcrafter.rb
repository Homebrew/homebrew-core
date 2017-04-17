class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.3.1.tar.gz"
  sha256 "b88e53ccffc00f83717f2e686dbed047b95f011187af2b7a23ba7f5cd3537679"

  bottle do
    cellar :any
    sha256 "bfeb52979c50e54e36638e516a764aa182d28469de8b05d974a47efbcc50cd8b" => :sierra
    sha256 "926a5324a81abc0c0466afae29c63508678049a166543f8e2c677065e81cb646" => :el_capitan
    sha256 "6e56726fcb30139819b22476a56b2107f678f40a57d37c0950e58d1db91de1be" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end
