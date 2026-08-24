class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "7c464cec24a40889ebb73ae22c86ff169678cd13f6e3e89293725043daf5b2d2"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4aa7c97d7b77d3f3148b728a0a247f434f5700ade75567745a2ac7f917378ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173e03fb3f190571cf54259de6335b449587dd5d5ebba70e0421ad9050e80ecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e97a9d9e3ac6be4a163ad333fa4abcc0997a7e8a7e99d02489a44c832415f02"
    sha256 cellar: :any_skip_relocation, sonoma:        "8250e89b6bdd11e93baebecbc2b4f61723d4c6ee73061bb05dc38aa783d26831"
    sha256 cellar: :any,                 arm64_linux:   "ea69798027e767689402ca90ef1316d6003eeaff4b32822b0f6b05d4dd4127a2"
    sha256 cellar: :any,                 x86_64_linux:  "d3dd6cac23a8ca95e0ebfe752670ba2dcda34f0de019fcfa11aa7e89bb810dc3"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  deny_network_access! [:postinstall, :test]

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
