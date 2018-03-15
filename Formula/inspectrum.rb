class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.1.tar.gz"
  sha256 "4baafa14b8a57cd3e460b4a11221a865c9fb97e0d8ead0adfa33fab93ac0339b"
  head "https://github.com/miek/inspectrum.git"

  bottle do
    cellar :any
    sha256 "bba517ed6db7cadf5bc26c649bab5ee49d08756e3460a3c6e6872d85c24e821d" => :high_sierra
    sha256 "6627a2702e5d75f37cfb111346de7af5aef161c96197011bb43551ee06e1d410" => :sierra
    sha256 "5de662e5b9a83d2ad3ef0ae103f80d3cbf4bb112b449d7d684970ca7d635dba5" => :el_capitan
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
