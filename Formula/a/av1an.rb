class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  url "https://github.com/rust-av/Av1an/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "58eba4215ffaf07a58065e78fb4aec8df9ebda48e9d996621d559f3024b3538b"
  license "GPL-3.0-only"
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  # Differentiate v-prefixed tags from old version schemes
  livecheck do
    url :stable
    regex(/^v(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9dc58aed5f017cf8a3de67b59c64c2a7e47ca23ede44d7061d9b7d4a64c1e4a"
    sha256 cellar: :any,                 arm64_sequoia: "0c8a0b7bde0ba5e50aaf21637ddd6a12e8c6d898d1c65b9efe9453cc5ccae2e4"
    sha256 cellar: :any,                 arm64_sonoma:  "b50c649273e7f4a172ded9c12430936a2fc9dc7b4a4cd0f47b3618807c0eed1a"
    sha256 cellar: :any,                 sonoma:        "1d396a96498150fe0abe85305c440d12050a0b561bb70fa022a7f534dcaeb864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a880b79680bee8ae19fa5f6156cd2112c2cdbf64d0bf30d950a37cdc1b65611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d176f8f98bc509f5b24b8d19daa35083c0e56c8387ee30fd5287d2b6b9c606"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    system bin/"av1an", "-i", test_fixtures("test.mp4"), "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end
