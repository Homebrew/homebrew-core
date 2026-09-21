class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.3.4.tar.gz"
  sha256 "15b5cb68b3598e51ca968316443c9fb9597b6230e9d692cb4e641d54505a97ec"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a2187370de11d987d11b0fbdea569f83235458327707c573c82d36d58274f0cc"
    sha256 cellar: :any, arm64_tahoe:       "b267ed3e0c71c3238d2bc2f6ff21a8f386a1fcbddb0bbe1e57b64d2b51d8cadf"
    sha256 cellar: :any, arm64_sequoia:     "85000a231b6b50d62f70305c66597a7a3631f3fe433848592a9a53536952ec2d"
    sha256 cellar: :any, arm64_sonoma:      "2107ac0e245aeac9b63d5fd93109bed5754d45151a77e906b83d970e4e009a24"
    sha256 cellar: :any, arm64_linux:       "f81cdea66cc1f8c368ae591769fbafeb4438cc36518a8b8020e426547827f0f1"
    sha256 cellar: :any, x86_64_linux:      "3527a4301886aa03bf1ff55d0cb6fdf03869d63cd90357731c6e596b58732674"
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
