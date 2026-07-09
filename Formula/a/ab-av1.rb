class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "a495fca2aace428d385944b25e49c56b5db4b328a1543becb4c181f138293d7b"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cab3bfe9b990b45cb8befd5c233ac2dc2058c67ebc1b838683a111ca45d8127d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f4c09aae97315c3fb8d06cd6e302d978cb1705d95f25025925e95192b6fee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7f25d3682e41b900b953d79ba95d8d99853124fcdb5b3fa266dcef0e4aea03"
    sha256 cellar: :any_skip_relocation, sonoma:        "045d04883b0822442a82ac21bba73ac5aad80d6d9d6d8c330d36370dc15b4306"
    sha256 cellar: :any,                 arm64_linux:   "cf8cc16604e2186333d399f2ac4e9b6be208709ae31376ebd71bc5a532218a29"
    sha256 cellar: :any,                 x86_64_linux:  "512d433d5714c9928b13f0e9ecc41ea8283f99c84aa28177cf91fa5ecdb2a992"
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
