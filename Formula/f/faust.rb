class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/grame-cncm/faust/releases/download/2.68.1/faust-2.68.1.tar.gz"
  sha256 "d4ee30e2444bed55b593c6c70ec4e330b71260819d4011b37d8c9b9c061e810f"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e355880d95cc9cb1f0411c8a8327a7d1e87e9b5e78c5f7dd41543084784f531e"
    sha256 cellar: :any,                 arm64_ventura:  "a0354cdea965ade3b8ca19b3b31c3942690560fcd5bb61016ce32e8e90f6cb8e"
    sha256 cellar: :any,                 arm64_monterey: "8f3b06b67c43cb8edb447dee45c0fc0df7482e22ba71b31db04f8a11ad9d7fee"
    sha256 cellar: :any,                 arm64_big_sur:  "8375f27903f2bd0f1dee073b3de81a07e7314040b7236e52278a56a3c492feb5"
    sha256 cellar: :any,                 sonoma:         "6ee0a0907cd136e82040a82981193a1acc84df99c4e4c27a2e5ba60758072c4f"
    sha256 cellar: :any,                 ventura:        "c789092307ddfe487c46ea67bc34ee1ec43aa56d6ea79b2ba089f8a54a8b5eae"
    sha256 cellar: :any,                 monterey:       "1fc2e43214eaed4a924dc27ad6d9409ac5b20259921259d273fdc51b71093869"
    sha256 cellar: :any,                 big_sur:        "ff8796eed8f6fe52446430ca66fdbb070cbace09e0f30d88bbd230a704c2ba06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838c1a2a66a5e8e2c6647e5e8fcb96cdb06f6094bdd8847fe318e86d0d56beb9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@16"

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
