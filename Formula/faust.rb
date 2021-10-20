class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.33.1/faust-2.33.1.tar.gz"
  sha256 "7185b43615588e4e52fac5f455ae0078661e20f87da806b31c4942ca377f9a0a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4bd42dda70facd749d115327250fc08907637c3d0afbf7baa66a1b4ad4c83718"
    sha256 cellar: :any, big_sur:       "fb9c0feafa370d43b0f6ea3e846a11b100def498a160ef5556005e248caa8b0f"
    sha256 cellar: :any, catalina:      "b648b47e1f52d5a3c810a36137261c914b7420c325c7ea22909588838e440712"
    sha256 cellar: :any, mojave:        "07f13fd3379b293917ec177cda749c7b9a542c2ae5816496bac74b8a8b790f56"
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
