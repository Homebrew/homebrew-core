class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.52.tar.gz"
  sha256 "df906463105f5f4273becc2404570f187d4ea52bd5769d33a7a8661a747b8686"
  revision 1

  livecheck do
    url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/download.html"
    regex(%r{href=(?:["']?|.*?/)gocr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2b0685b69077fae51701a4ebfc36619427991082786e7f1bfbae287902843f70"
    sha256 cellar: :any,                 arm64_big_sur:  "a3639ecb89f70562106db696e43f8ccdbe770b812ba2cdc695637b5f8e8dba7f"
    sha256 cellar: :any,                 monterey:       "6192d502b84bcb9d0546174a0b9ee6ddd9c2fe687b6d0b1509e8d2403c2fd0ee"
    sha256 cellar: :any,                 big_sur:        "e2fecccba7638297e89075dd8a21bf64d124a9f4f341f2437411abadf90b1f33"
    sha256 cellar: :any,                 catalina:       "d0408f223b941c6d81c0edd843ab5916475a4ea4b94892b548da6403e4c3af2a"
    sha256 cellar: :any,                 mojave:         "d173d60e8d8f139b4e7e310b84d1bfc56e406eb026c51beba9d4b2facaac3ae1"
    sha256 cellar: :any,                 high_sierra:    "2a5cfa5a815706b2ecb11658ad9132bba21de5304e4541118d8d061a5bb7779a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc5af66eb1d5e1345c1599d57da5a4695f7d37975ba96bfa97dd481ec3a7b1c"
  end

  depends_on "jpeg"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gocr/0.50.patch"
    sha256 "0ed4338c3233a8d1d165f687d6cbe6eee3d393628cdf711a4f8f06b5edc7c4dc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system "#{bin}/gocr", "--help"
  end
end
