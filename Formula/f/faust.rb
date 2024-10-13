class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.72.14/faust-2.72.14.tar.gz"
  sha256 "dcd5aaf263c59d34c385e65c4f4c5b85b0e9435e57cbfd79bb67a01e5780acf0"
  license "GPL-2.0-or-later"
  revision 2

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "7722859fde12c41f92196bcc9b4925cb69f4b5455b5c65714cbfa8ad329d4f2a"
    sha256 cellar: :any, arm64_sonoma:  "7e80c8851f8d42da0e709a35c3da65ec70c230c875a8e09cc4436ca4d840d6d4"
    sha256 cellar: :any, arm64_ventura: "fe765dd3e97eba9c63b943c65db2ae9a11a79ebe2cd1dd01c02daaf54be5d2d6"
    sha256 cellar: :any, sonoma:        "5138e86243892021eb49290bb60fd4d095c6c8852551aee39859224b91ff575a"
    sha256 cellar: :any, ventura:       "16e35bfd4838ac328996ddf5d44bb674961af25b5328c1869faf60f87cdf91d2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@18"

  fails_with gcc: "5"

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
