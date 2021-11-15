class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftp.gnu.org/gnu/ocrad/ocrad-0.27.tar.lz"
  mirror "https://ftpmirror.gnu.org/ocrad/ocrad-0.27.tar.lz"
  sha256 "a9bfe67e9a040907aff5640dca56392476b6a89e48e37dc94ba846c5b6733b36"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899b2acf05936624225cb01993f3f993bf9e3cc73c7052051bed917defbd83e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfbe36f994bcbba6286b9bec6206e314d405a42ca222821648a6962b17a2aecb"
    sha256 cellar: :any_skip_relocation, monterey:       "e0ec4ee19228ce64ba4da65f84a14bf7bd55e6f28b5d2584b7c49505c1abb51b"
    sha256 cellar: :any_skip_relocation, big_sur:        "59bfd9714c393b8910fdd9cbc337dfeaf431f78215820ffe47fe59841231e7f4"
    sha256 cellar: :any_skip_relocation, catalina:       "6533cd452587714531d20b4aa74ea7fc1e323ff893c8a7c9729655ede1ec9df7"
    sha256 cellar: :any_skip_relocation, mojave:         "3d1c85bb36faedf5ab12f78e8c3511dcc4164561ba8bc09924b48f6aa3fa0b37"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ba9b30eeabc11634502e30fd9a730d5727668550f9708d46fbefc03bcb3917de"
    sha256 cellar: :any_skip_relocation, sierra:         "903ce6530395c0973418020561ddd60da739f3a36e865500776922e18975460b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834afd1cc5f7c095ded49166800e56137105f2777a89d877b1c9ca1bd6ad1779"
  end

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
