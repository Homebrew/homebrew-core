class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftpmirror.gnu.org/gnu/ocrad/ocrad-0.29.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ocrad/ocrad-0.29.tar.lz"
  sha256 "11200cc6b0b7ba16884a72dccb58ef694f7aa26cd2b2041e555580f064d2d9e9"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "116d23e8c9dd05261d3591a6c71bc68f21eaf4f31ecb196ab1663a922a382e4a"
    sha256 cellar: :any,                 arm64_sequoia:  "e64667cc0efcf07cbbdb3459f9cbb88be11b2718b75417226e910e2cfb71a5a4"
    sha256 cellar: :any,                 arm64_sonoma:   "36d45f3af4754048ddde02ce9b7d9668ae188d7140b76aeda80f65ee6bb69a17"
    sha256 cellar: :any,                 arm64_ventura:  "31bd92179ff109e10d90fbf1af54975c3a9728af8aaa01af5111ab1d6e8cc7e9"
    sha256 cellar: :any,                 arm64_monterey: "109021715122dda81422d1867d6a11e8f06bf677b0e17a6a8b3db38338aefc3a"
    sha256 cellar: :any,                 sonoma:         "0b70492d341de711f603f80862cc1843a6f95b618845e0e20e4abfafe1957e2b"
    sha256 cellar: :any,                 ventura:        "f3676e32c5accf4cee24e327c6bf21d300d9256245d5e22a6a52e5b15cfcb8dc"
    sha256 cellar: :any,                 monterey:       "10c391fc9278aca909ff4af61c971a3cda1410b6c16b80461e3b894aebfd3f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3084377e8340cf1599a2d841e69252f5e6320801154cca9f9ec9d6e8b85b2762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee19eae3b90d6753c188ab4db09ccdf39b2df45d8ecafb91c122935c83c5fef"
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      # This is an example bitmap of the letter "J"
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    assert_equal "J", `#{bin}/ocrad #{testpath}/test.pbm`.strip
  end
end
