class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.37.3/faust-2.37.3.tar.gz"
  sha256 "f14577e9f63041ec341f40a64dae5e9362be8ed77571aa389ed7d389484a31d7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "12b8c83359c815e0a56662f53bdf75a7b6c20feac9e29cc72aad4d1f821f2002"
    sha256 cellar: :any, arm64_big_sur:  "4bd42dda70facd749d115327250fc08907637c3d0afbf7baa66a1b4ad4c83718"
    sha256 cellar: :any, monterey:       "67df30f6d5def23ac17526385e9ea6b5baabb67a80af29918075db0caa3c6468"
    sha256 cellar: :any, big_sur:        "fb9c0feafa370d43b0f6ea3e846a11b100def498a160ef5556005e248caa8b0f"
    sha256 cellar: :any, catalina:       "b648b47e1f52d5a3c810a36137261c914b7420c325c7ea22909588838e440712"
    sha256 cellar: :any, mojave:         "07f13fd3379b293917ec177cda749c7b9a542c2ae5816496bac74b8a8b790f56"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@12"

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
