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
    sha256 cellar: :any,                 arm64_sequoia: "bb7217a3720d56704ad9cfff388619ebcdfa2937545ca84ee73727791ed1e115"
    sha256 cellar: :any,                 arm64_sonoma:  "b55c0b1f2e601ae24e2bfb9f11991b741a3c9ba15bb55517640b45cb1d5c9a40"
    sha256 cellar: :any,                 arm64_ventura: "41e1b6bc77c93898b52873cd2e31f6d09dfac0f7a76ee171a3c89b6f5f0f2563"
    sha256 cellar: :any,                 sonoma:        "4f8440d683e66503cc04cf1b840352e136e7b8bbfba6c6b38509b0d0f7df0e6f"
    sha256 cellar: :any,                 ventura:       "7d59f966def7215621a4fb02434ba40bd5fde603d9a35249b9487763dd0237c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26344ca072bd802c0bd13d2b93c7f99707306422400f179c308ec644e1b6b74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fad536442934f2b445d98eef154abc16ddf4ae62888f22b16bde5aab88183e3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

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
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin/"faust", "noise.dsp"
  end
end
