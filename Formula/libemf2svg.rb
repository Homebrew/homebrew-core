class Libemf2svg < Formula
  desc "Microsoft (MS) EMF to SVG conversion library"
  homepage "https://github.com/kakwa/libemf2svg"
  url "https://github.com/kakwa/libemf2svg/archive/refs/tags/1.1.0.tar.gz"
  sha256 "ad48d2de9d1f4172aca475d9220bbd152b7280f98642db561ee6688faf50cd1e"
  license "GPL-2.0-only"

  depends_on "argp-standalone" => :build
  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"

  resource "homebrew-testdata" do
    url "https://github.com/kakwa/libemf2svg/raw/1.1.0/tests/resources/emf/test-037.emf"
    sha256 "d2855fc380fc3f791da58a78937af60c77ea437b749702a90652615019a5abdf"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-testdata").stage do
      system "#{bin}/emf2svg-conv", "-i", "test-037.emf", "-o", testpath/"test.svg"
    end
    assert_predicate testpath/"test.svg", :exist?
  end
end
