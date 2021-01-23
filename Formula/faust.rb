class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.30.5/faust-2.30.5.tar.gz"
  sha256 "6cf64b8ee92c2db74d7d83d726b0ecb6f7e141deeadf4cd40c60e467893e0bfc"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "6bca64d09f6bc052c71aaa01b1345294dab92dc30e7e02ec2775cf332d6eb310" => :big_sur
    sha256 "20e2b5c9da498fa087525af5152b1dae659a0469e7aafaa17272a000a8aa7247" => :arm64_big_sur
    sha256 "3e17a2b3203fdf2851afde34281373fb2d8fe908e224f380bb1692aac8ee7564" => :catalina
    sha256 "96f641dec558778e6e652bea11d4b446bcc7c61bebec5ec314862479b22989d7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  def install
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
