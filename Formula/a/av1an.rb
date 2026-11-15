class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  url "https://github.com/rust-av/Av1an/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f58096a084456acf66f2be273b6c70e05cb53831b2a8a5006569f08a5a7b575a"
  license "GPL-3.0-only"
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  # Differentiate v-prefixed tags from old version schemes
  livecheck do
    url :stable
    regex(/^v(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cac6c7ed1af8cd38f2a55af4605ea995af7b72c0ef6dbd9c2c33ea8bcc7a58a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b336020ed3ba0b195b825dc5aaed6d3573ad1720b341b99999a4b5a418fc16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13b90634026f8e4058a6007fe1bf34f3ad8ff847bcd5114096d253f4b39fadf1"
    sha256 cellar: :any,                 arm64_linux:       "ff0b12473a72a9f2ceafdce673bc16ed0ca8a405b96f7a23aa493cf6445b29ad"
    sha256 cellar: :any,                 x86_64_linux:      "3e1fd76ca1a8d3888d8fdb3640e42e5000b3cc3a270c2f259877e93e6172229a"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", shell_parameter_format: "--completions=")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    cp test_fixtures("test.mp4"), testpath
    system bin/"av1an", "-i", testpath/"test.mp4", "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end
