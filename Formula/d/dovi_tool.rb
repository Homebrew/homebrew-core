class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.3.2.tar.gz"
  sha256 "8e1ca50219a68ba27a200ea1dd4210a6ef232b5f66d1b6ffc4a8303c87fe16bf"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81c1c94dd315789c85def55bb8fcb7f297be401239e9132f2f4c22baf7009532"
    sha256 cellar: :any,                 arm64_sequoia: "4fd138789438a2e488019d70154c52c9e41f31261baa99db926bd0b0ae65ab1a"
    sha256 cellar: :any,                 arm64_sonoma:  "e08172d3ba5dbb923ba92b064377338c4d4be1ed9ad8503e5d9da1487281d432"
    sha256 cellar: :any,                 sonoma:        "39f780763832297e81d97b3d729e4b8505876f10c2892974fc7e45ba2c26eff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c986986476ecea0de572803691294ef2607bd8a963000f088f23ebf7a173fb05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d80749c54d45aa4d0ec45a54ecdb421dd3005b106f86a4412ac23ec9c47bb4"
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
