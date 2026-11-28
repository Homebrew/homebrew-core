class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2117ebd7091f6d22423bbfbf24bfffa53178babc24ae984174ae20014bd8bf7e"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    manifest_sha256 "c3ea1b170dcbbe2f91eadc006ad14f711b719ac2b4a41d79ca60becdad709ab5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "380c27101a92878daf03f6861bf27c7c55768ea0a8ba0de6e162c3c226d917b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d395dd46e581282927b7f416ce5be0491f0f75414812ac9a651bcb5963a5a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3084d1adc34bade53059b76b11b7a66f8b8ea8eb8c20d7c212e56e1f51f2f574"
    sha256 cellar: :any,                 arm64_linux:       "c35920100b654e0c97d843e718c562f843fb4cba271a52612eb4ec51d97ced3e"
    sha256 cellar: :any,                 x86_64_linux:      "dd33c6de845dc4256b65820a84fe67fa9479adcd625ac7157c655938b96de614"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    # Create a 5 second test MP4 (same as ffmpeg test) as the test fixture is too minimal
    system formula_opt_bin("ffmpeg")/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", "test.mp4"

    system bin/"ab-av1", "auto-encode", "-i", "test.mp4", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end
