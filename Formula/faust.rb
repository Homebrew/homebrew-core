class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.30.5/faust-2.30.5.tar.gz"
  sha256 "6cf64b8ee92c2db74d7d83d726b0ecb6f7e141deeadf4cd40c60e467893e0bfc"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "6d80da1e64a967bbc9549653d1848dba6ffdd8b54d99e1ed1b507ecfbdf84136" => :big_sur
    sha256 "180d720686402bbeb9ac2f18c1c3c0d66282a2443631ab1961ec0b6d2b1e459b" => :arm64_big_sur
    sha256 "975ec4c8a2c10a975f998a94466734a5f3c08ceefb5c024d40d5d394a994754d" => :catalina
    sha256 "35e5b689fcec1730122ac0871d4c13eb3b84842991cf9728180fd84f4a654cf5" => :mojave
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
