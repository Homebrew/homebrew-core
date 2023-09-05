class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.31.0.tar.gz"
  sha256 "8a88e9433cad4cfc4269d45acbc820c41a333a965b59ce42d81d925422d1a026"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d3e127abd1e657e10f7ccf6272c33297dd2c6c7db41ea6530061de42797e072"
    sha256 cellar: :any,                 arm64_monterey: "3aad51926581a91abd4d894ce98a800b3cbd584d3938f81484ffc297162de8e9"
    sha256 cellar: :any,                 arm64_big_sur:  "d055a492f1ff9106e4180affe304f2d0f82cdb13d1a732f2c8e5c4e3f541a494"
    sha256 cellar: :any,                 ventura:        "9d7eeaa7d94215ac91ca574a26b9aa7420ac4d3bcfa10c5733a9d3dcf58e6124"
    sha256 cellar: :any,                 monterey:       "e21ccaac7d8b125f8b2b2a2660a2dd05e75064fe9834cd03eda9911bf7c006dd"
    sha256 cellar: :any,                 big_sur:        "fdefdfe979c0f75b84e8425fd95b7ea3cb3e3f7bddb0a03c96489dd1a7b26971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10e94997135138c50255614b0abc6cf79814ab861aa4114a3894212ab133e336"
  end

  depends_on "xz"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Remove on the next release which has commit try both python and python3
    # Ref: https://github.com/arq5x/bedtools2/commit/ffbc4e18d100ccb488e4a9e7e64146ec5d3af849
    inreplace "Makefile", "python", "python3" if !OS.mac? || MacOS.version >= :catalina

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
