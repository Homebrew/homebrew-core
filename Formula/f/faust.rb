class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.79.3/faust-2.79.3.tar.gz"
  sha256 "ca2171cb136f135960be10fee2c1728304865a5d5190e9a03cace88b4936c558"
  license "GPL-2.0-or-later"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f2d2825b45f8abff31f6c0883567208f6491a4d617c03f8a352d6690e817818"
    sha256 cellar: :any,                 arm64_sonoma:  "adbcdc945b4702906971f7256d228b086adaa619a94101d13f69a47f148fb2d1"
    sha256 cellar: :any,                 arm64_ventura: "4eb43d2bfddac4f5ace07635cbdc45209c8fd248604f167221b507af376d2e88"
    sha256 cellar: :any,                 sonoma:        "44ed258f265cb9c8bf69d7165febfb8ce2ab78046883d46fffae0173ff858606"
    sha256 cellar: :any,                 ventura:       "35d557f845bd2f50b9cba2478f095f5c26e1194d733dd1afd461da2e61ef797d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6fcc600583028c1535b9e09c4d5796668673889aca3e66e847d49efb7b9c11"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  def install
    system "cmake", "-S", "build", "-B", "homebrew_build",
                    "-DC_BACKEND=COMPILER DYNAMIC",
                    "-DCODEBOX_BACKEND=COMPILER DYNAMIC",
                    "-DCPP_BACKEND=COMPILER DYNAMIC",
                    "-DCMAJOR_BACKEND=COMPILER DYNAMIC",
                    "-DCSHARP_BACKEND=COMPILER DYNAMIC",
                    "-DDLANG_BACKEND=COMPILER DYNAMIC",
                    "-DFIR_BACKEND=COMPILER DYNAMIC",
                    "-DINTERP_BACKEND=COMPILER DYNAMIC",
                    "-DJAVA_BACKEND=COMPILER DYNAMIC",
                    "-DJAX_BACKEND=COMPILER DYNAMIC",
                    "-DJULIA_BACKEND=COMPILER DYNAMIC",
                    "-DJSFX_BACKEND=COMPILER DYNAMIC",
                    "-DLLVM_BACKEND=COMPILER DYNAMIC",
                    "-DOLDCPP_BACKEND=COMPILER DYNAMIC",
                    "-DRUST_BACKEND=COMPILER DYNAMIC",
                    "-DTEMPLATE_BACKEND=OFF",
                    "-DWASM_BACKEND=COMPILER DYNAMIC WASM",
                    "-DINCLUDE_EXECUTABLE=ON",
                    "-DINCLUDE_STATIC=OFF",
                    "-DINCLUDE_DYNAMIC=ON",
                    "-DINCLUDE_OSC=OFF",
                    "-DINCLUDE_HTTP=OFF",
                    "-DOSCDYNAMIC=ON",
                    "-DHTTPDYNAMIC=ON",
                    "-DINCLUDE_ITP=OFF",
                    "-DITPDYNAMIC=ON",
                    "-DLINK_LLVM_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "homebrew_build"
    system "cmake", "--install", "homebrew_build"

    system "make", "--directory=tools/sound2faust", "PREFIX=#{prefix}"
    system "make", "--directory=tools/sound2faust", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin/"faust", "noise.dsp"
  end
end
