class Crfxx < Formula
  desc "Conditional random fields for segmenting/labeling sequential data"
  homepage "https://taku910.github.io/crfpp/"
  url "https://ftp.heanet.ie/mirrors/gentoo.org/distfiles/CRF++-0.58.tar.gz"
  mirror "https://drive.google.com/uc?id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ&export=download"
  sha256 "9d1c0a994f25a5025cede5e1d3a687ec98cd4949bfb2aae13f2a873a13259cb2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fdd9f33025deabd3d876f02e61085a45eb3269d0683104a3cac519eb71d9f692" => :mojave
    sha256 "da6226d9f8244df1ff1c017e0440aaad90c6907d6213e3fea3472ca75a089d27" => :high_sierra
    sha256 "67e6219d0cfd90d5ff2e46834ad9c835889e1aebca7940f738bd78314fbc6194" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end

  test do
    # Using "; true" because crf_test -v and -h exit nonzero under normal operation
    output = shell_output("#{bin}/crf_test --help; true")
    assert_match "CRF++: Yet Another CRF Tool Kit", output
  end
end
