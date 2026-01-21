class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "e8978c23661db5ce114f1905768b4378b75d435a95608f99a62be98aa8d6f094"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70ddc335db8cc07b54248e54c670b920e365289abf07f9e74c9744352b585bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd771a3dc157486da2bf1685c6e02c1d08a4681b46503349d833f3570401190b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8790e10509574492ee8dd24d57f4ef5e82628e2a5267800eb03c463d284aa98"
    sha256 cellar: :any_skip_relocation, sonoma:        "b60c969f26f77a6728e2297d1ee4b4f614723c33443b8edf78b7bb12a1c647cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254a3a63db772c498d24891dbccec3a0427fe6982f0b9bf29812cee16549d582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e8de073aa07641afc7bc4e188ac5ff7f7cdef60e90be9a863ff162c8bcc624c"
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
