class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.81.8/faust-2.81.8.tar.gz"
  sha256 "2bc6ca210957008dfb8423e65e135b65938acf345299ed05d655c290b1c44a11"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c63ae6d26a33ecf3d9231b5ac1a75b4a9ec7c3b5e9ae38775bb91e7882ee8dd8"
    sha256 cellar: :any,                 arm64_sequoia: "f026127aaf3d4122e4ec584c94cad7a2e705dc3a6be8bdd20862a7afca12a6c3"
    sha256 cellar: :any,                 arm64_sonoma:  "180bac0f4952d763b8dbea74a15faa8cba738c241a082506bbc3ddb1d4e17b9e"
    sha256                               sonoma:        "a18c9563d11c151639252e8328da865fe2cbe7f2954eabe0f2086609c00807dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5658a77c19930cfef1ce154ae9495a021a018ee8e69e5698aa30c702151b5c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760cb14ca664bb8556103910dae5125b2d99e8282e8439c7de3b03868a13dd9d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  # Fix to add shebang for `faust2wwise.py`, remove in next release
  patch do
    url "https://github.com/grame-cncm/faust/commit/bbf44bcc16b093615a86771309ab5a79d366fcd0.patch?full_index=1"
    sha256 "21ddf9f006fe0a98addb94c248b145c1290df4a3abb7650d83293d2ead96e9fe"
  end
  patch do
    url "https://github.com/grame-cncm/faust/commit/d254b879a837ac5eb24c222629804814e810426f.patch?full_index=1"
    sha256 "5abfa30121d4314247c97955d9e5d7df2cc5ebcdf2e6f0ef6b8b0cee8a998691"
  end

  def install
    # `brew linkage` doesn't like the pre-built Android libsndfile.so for faust2android.
    # Not an essential feature so just remove it when building arm64 linux in CI.
    if ENV["HOMEBREW_GITHUB_ACTIONS"].present? && OS.linux? && Hardware::CPU.arm?
      rm("architecture/android/app/lib/libsndfile/lib/arm64-v8a/libsndfile.so")
    end

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

    # Remove Windows files
    rm(Dir[bin/"*.cmd"])
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin/"faust", "noise.dsp"
  end
end
