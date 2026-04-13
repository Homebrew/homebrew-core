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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "75f1beb607c47cff64d09ffd0eceabeec3e466c34a8e6881ae99982799f4d8b3"
    sha256 cellar: :any,                 arm64_sequoia: "c3c3a289774f78ef13f8536e0d3b1c321dd43d60069046792e21561aeda2d775"
    sha256 cellar: :any,                 arm64_sonoma:  "132b521887366ef46ca8198fbb56fceb3621137654a0e89cf6fd8025cb26d65d"
    sha256 cellar: :any,                 sonoma:        "5f24497cd78557437533160947f715b01ba31fd128e890900e957eca999a25ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66278ee1f9af5a00b9cd90245ce9190ac74897f4d964fa58aa9f20ed1aa35b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358e252cb21347a5d92519bcb0eb7ba256a1f22410f8735efff523bc10a6ba05"
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

    generate_completions_from_executable(bin/"av1an", "--completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    system bin/"av1an", "-i", test_fixtures("test.mp4"), "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end
