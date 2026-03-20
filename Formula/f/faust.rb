class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.83.1/faust-2.83.1.tar.gz"
  sha256 "6ca3d749296191c41e9fd24ce7e5b37f58022d4320acb1c7343fec2df82d5551"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a97c75e474df98e3b419f0cfbf2cf9b2247b33de4e23fc9856508a6d2c90013c"
    sha256 cellar: :any,                 arm64_sequoia: "36ddd63d6e09b68c39098ab01efbcae1b1b0b103b97b9f66fa7edc5ab2447714"
    sha256 cellar: :any,                 arm64_sonoma:  "01dc8eead738c4d8f5065537b67b23dd3b73152e7f3384d3b8ebddf2592e08ff"
    sha256                               sonoma:        "9f72314e797fe96dc84196bd009c8aaf62247d1ea57aaf7a8cdb58469fd7e9aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f6c7b28186cd4acaf5a40140575ceecc495100cee531f49d18d2a0cdf101e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcb7a3a9474c2f40132b7b19ced339b85fbfc468c84a806e2a0e9ce277b73e5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  # Backport support for LLVM 22
  patch do
    url "https://github.com/grame-cncm/faust/commit/cb26e3a4afba8e766611046d5be3075016fe3f1c.patch?full_index=1"
    sha256 "1a868637d80263c99dc7aa0128e847d82994eb559abd10a6cd037869853b2079"
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
    (testpath/"noise.dsp").write <<~FAUST
      import("stdfaust.lib");
      process = no.noise;
    FAUST

    system bin/"faust", "noise.dsp"
  end
end
