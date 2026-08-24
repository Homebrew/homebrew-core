class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.85.9/faust-2.85.9.tar.gz"
  sha256 "0cd00968f81357b78df64c25aad12ec94bd4b75bd489ca0449fe7f7b1ad0efe1"
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
    sha256 cellar: :any, arm64_tahoe:   "583df2489e564948010f63e7db96c3946620b6574d9ea6f55c180cd1de0e3609"
    sha256 cellar: :any, arm64_sequoia: "a91455ad39ceab4f8c3f9bb0f82850544b68bef53dbc8b8023f96a3424a5c25d"
    sha256 cellar: :any, arm64_sonoma:  "31c47744240b27588a6f08f34910d8a50d1a2d06e6284905d88c311f3a09bbf5"
    sha256               sonoma:        "45ef79ea86ca9938652bcf5f7f743c64765d1f3c8d6481538b94feb1bbd542c5"
    sha256 cellar: :any, arm64_linux:   "88b69a7855ffced9d18c3e2b8724d55e0fa17c9a3c9a28f6ffa05b6d4fbb2180"
    sha256 cellar: :any, x86_64_linux:  "50b0845bc291fd3fca26b1c00d5e0096cb194a8a13619081c5753a0e84a6809d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@22"

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
    (testpath/"noise.dsp").write <<~FAUST
      import("stdfaust.lib");
      process = no.noise;
    FAUST

    system bin/"faust", "noise.dsp"
  end
end
