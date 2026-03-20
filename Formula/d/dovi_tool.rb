class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.3.1.tar.gz"
  sha256 "090888c35da017e290614b70108653ea975034c23b48ddd459538a1a6e4cc05a"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4fe6538417109e21ad4f85ac51d122561c7422367924a76b001c757f4da239f3"
    sha256 cellar: :any,                 arm64_sequoia: "627d237f20823e9808125da935ee82b276525efb00e513a1da9608c384014fdd"
    sha256 cellar: :any,                 arm64_sonoma:  "33fd11db3b81785613f4ef467e416650efad1b9f2b902466530623bf6bea66b3"
    sha256 cellar: :any,                 sonoma:        "ba6d602037df67196a73a5d2f9e2839976e3b0587bba61d7769783231957c432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c791123617f40517602bd82e316ab8eb4045e146dc01291ebdc50dd58f76b88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb370cab1028ed749676dbde706c1b2bfaf58f5057cef5edaf31e4b2d1b3c5ab"
  end

  depends_on "cargo-c" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "assets"

    # Install the C library
    cd "dolby_vision" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                      "--prefix", prefix, "--libdir", lib
    end
    pkgshare.install "dolby_vision/examples"
  end

  test do
    output = shell_output("#{bin}/dovi_tool info #{pkgshare}/assets/hevc_tests/regular_rpu.bin --frame 0")
    assert_match <<~EOS, output
      Parsing RPU file...
      {
        "dovi_profile": 8,
        "header": {
          "rpu_nal_prefix": 25,
    EOS

    assert_match "dovi_tool #{version}", shell_output("#{bin}/dovi_tool --version")

    cp_r "#{pkgshare}/examples", testpath
    inreplace "examples/capi_rpu_file.c", "../../assets", "#{pkgshare}/assets"

    system ENV.cc, "-o", "test", "examples/capi_rpu_file.c", "-I#{include}", "-L#{lib}", "-ldovi"
    assert_match "Parsed RPU file: ", shell_output("./test")
  end
end
