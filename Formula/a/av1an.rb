class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  license "GPL-3.0-only"
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  stable do
    url "https://github.com/rust-av/Av1an/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "21da3eda3f4c8b0fda0dd2b63ae6f35d9ca3c78e1dc01a11f0a1f9b31c817e90"

    # Parse `nb_frames` from ffprobe as string
    # https://github.com/rust-av/Av1an/pull/1184
    # TODO: Remove patch on next release
    patch do
      url "https://github.com/rust-av/Av1an/commit/ade862fb44b2d8f24e61fd41b255783110ec21ea.patch?full_index=1"
      sha256 "54943101a2e841fe3f11c00c62b92a34d6a705d7ada6b298a4d6023ffa20ff72"
    end
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "vapoursynth"

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", "--completions")
  end

  test do
    resource "sample-mp4" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end

    assert_match "av1an #{version}", shell_output("#{bin}/av1an --version")

    resource("sample-mp4").stage testpath
    system bin/"av1an", "-i", testpath/"sample-5s.mp4"
    assert_path_exists testpath/"sample-5s_svt-av1.mkv"
  end
end
