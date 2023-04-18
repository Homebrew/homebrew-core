class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.30.0.tar.gz"
  sha256 "c575861ec746322961cd15d8c0b532bb2a19333f1cf167bbff73230a7d67302f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2e8a782328689c862e6bda675fc80554974a9e4d31b87c2437ebd138146dc10e"
    sha256 cellar: :any,                 arm64_monterey: "f49bc2e2da620dc8e11f972de610ba8c181e187f326b0e684c3886fa0b3724f6"
    sha256 cellar: :any,                 arm64_big_sur:  "142bd16e4896e944960d472b3f0063b7e15785ecc6eea30da9a25d70455868b4"
    sha256 cellar: :any,                 ventura:        "4e142190372423e97db273ee80646b926b9298a857d4e3bd15316286ee37de5f"
    sha256 cellar: :any,                 monterey:       "6cb9009902dc477cdd5c22c8a5868f2a7ff60b0c5a5f09461aa9ddd6380385f9"
    sha256 cellar: :any,                 big_sur:        "cf105e55c3da5874d9c351c13c341b0898fa48731aadf5dc1b08b02f1ef36733"
    sha256 cellar: :any,                 catalina:       "775e107f0f6de74aaaf1f03a3d2441355a740e2198b7d3f9cc41bb0108338a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8396c0906988ec6abf7324769e46a673ae7f960761c628dedd74ac9ea3b3aa82"
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
