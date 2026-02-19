class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "e0f1f9744d3d5af423f4dd289e2c822c0f27c2c0e0e5747ea35c1ac5cb8f41f6"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9774d78be5545bef62616092595b4ce978919f9811976cd870f61855629d5009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b2bd5141c4807c4e05cd79c8cadedd7d14394108852e842a60d26f7ef321a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2149d07ebe9c3913f148fb877e91020130b3f82da3a39944873d36be88a7c0fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aeeb6d4cb51bb13c6916d24e000bdb097c1a21017691f7cd31bf13d6aa2578c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3836ef15ba9111b0510f172ad90e0231837cb7ef0f789323ed6483375c5f94b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1e39653749b1555dda96b9ca869b5da1b8b336aa22a8340bc1882840bbca91"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    system bin/"ab-av1", "encode", "-i", test_fixtures("test.mp4"), "--crf", "32", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end
