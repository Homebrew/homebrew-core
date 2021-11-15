class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "http://gva.noekeon.org/blahtexml/"
  url "http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz"
  sha256 "c5145b02bdf03cd95b7b136de63286819e696639824961d7408bec4591bc3737"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8783f6707647e97b97332dfae2ae2705823786ac65977d239e9d38dfb1f5b0c7"
    sha256 cellar: :any,                 arm64_big_sur:  "83b3c821686faba9f464198f22fc7432001e93d09c66192ff95c8d9ddbb69a80"
    sha256 cellar: :any,                 monterey:       "a959c9373710994104947e5fe99e22d8824c5523fc4974e5634560d02cec0813"
    sha256 cellar: :any,                 big_sur:        "b65b2c94d4c7b015a9ebf54ca27d71d52e09fc946ea1ecd170c952f3d262a599"
    sha256 cellar: :any,                 catalina:       "3f883672f92e2039c22bb278ca50ece210c2c01e58f4c230c3ab1e3101eeb74f"
    sha256 cellar: :any,                 mojave:         "23f943fa053e861b0f6c9f2e9cfa1c74d6b8966ac698e6650386d44f7d7de31b"
    sha256 cellar: :any,                 high_sierra:    "c2696cdaa1724541f0d07900219247365e30061a471df0b80f6469b3bc2b4a14"
    sha256 cellar: :any,                 sierra:         "bcd628072b5b7d6625e2b2caad1c6f64483807facda1b2eff32795de1b25070f"
    sha256 cellar: :any,                 el_capitan:     "b1788b8622b704c67b11295f6bf84ab881298980f8101b5fed6cb7441b4edc82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d59192ccfff76b31b99071e19cbb24bddc8e98260d8d922fdf336fc695e5b8"
  end

  depends_on "xerces-c"

  # Add missing unistd.h includes, taken from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-mainPng.cpp.diff"
    sha256 "7d4bce5630881099b71beedbbc09b64c61849513b4ac00197b349aab2eba1687"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-main.cpp.diff"
    sha256 "d696d10931f2c2ded1cef50842b78887dba36679fbb2e0abc373e7b6405b8468"
  end

  def install
    ENV.cxx11
    if OS.mac?
      system "make", "blahtex-mac"
      system "make", "blahtexml-mac"
    else
      # Parallel make has a race condition between mkdir and file write.
      # Fatal error: can't create bin-blahtex/main.o: No such file or directory
      ENV.deparallelize
      system "make", "blahtex-linux"
      system "make", "blahtexml-linux"
    end
    bin.install "blahtex"
    bin.install "blahtexml"
  end

  test do
    input = '\sqrt{x^2+\alpha}'
    output = pipe_output("#{bin}/blahtex --mathml", input)
    assert_match "<msqrt><msup><mi>x</mi><mn>2</mn></msup><mo ", output
  end
end
