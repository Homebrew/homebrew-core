class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "795d0ac7f241d22930456eeff9a75e142cef150b7bf3365fb57b298c6557ef0a"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "800d7dda4433997fa81b9abe19faf274b647fc56ec0da8d901daf6e32fdd6dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d852e18f09e2fcc76ea086502558f9330046ecf89ea1b200a10b50b251b57355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b58144acd8619ab22df4f631809d40d16ff3f39e2200e3e6b1b1a46db9d255b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e3e4ff5915bcde7121ff94b77216404b65e08048838bec5f2a812dde93b307f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030e005f23208da1f8ad43526233b73a0fdec91553146ffa1679d2c3ac95a75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208b08dc100a6dd6c2f7b990dc5d620bf984f464e4ef60e793888dabcfd2206c"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    # Create a 5 second test MP4 (same as ffmpeg test) as the test fixture is too minimal
    system Formula["ffmpeg"].bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", "test.mp4"

    system bin/"ab-av1", "auto-encode", "-i", "test.mp4", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end
