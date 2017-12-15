class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.tar.gz"
  sha256 "50b7db9b86208f414c387700a358eb58364094f3e8a4985f586f4f815645898a"
  head "https://github.com/miek/inspectrum.git"

  bottle do
    sha256 "c982163a1a70eb676d6fe8e9744a25e03edeea31744ce30beef75f6c47e924d1" => :high_sierra
    sha256 "b34f9c01e3a888f97d1c832c7fbcf4f4a036c3bcf47f058b81f41affe4f0f94c" => :sierra
    sha256 "f384448eac77bffb041890951b4ba401b11587eefc9d089162fbe63b7cd08e42" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "-r, --rate <Hz>  Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
