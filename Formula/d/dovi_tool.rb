class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.3.3.tar.gz"
  sha256 "b4906f67b339b10f885a5c7d89364a359cbd3845f3b95115cac5d7964e13422d"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "18c18c60d697c0b91ee94f587b63e805a5931262d2255a066948d91c13cbd8fa"
    sha256 cellar: :any, arm64_sequoia: "4ee5260084bcee0eec15184c9dd2eea80f40a03fdd1ffeb043199260d00ee0ba"
    sha256 cellar: :any, arm64_sonoma:  "a702f99d16cc4f2cce1ded9bfb07c4b4a558aa2ce77bd046704ae388c7240efe"
    sha256 cellar: :any, sonoma:        "e8bb9064f9e06855a57c649541d47528f2725d3b6327a6b3b7b8f89492284837"
    sha256 cellar: :any, arm64_linux:   "c7006f03437e3c6e8eaccb44513c53039a20badcf012c42766c24d3d811ec1d3"
    sha256 cellar: :any, x86_64_linux:  "ed443de19096f6132e87dc1ce0f2608ea7e2f883d0967ccbec4ccea742bba250"
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
