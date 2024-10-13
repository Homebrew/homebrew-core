class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https://github.com/kattouf/ProgressLine"
  url "https://github.com/kattouf/ProgressLine/archive/refs/tags/0.2.2.tar.gz"
  sha256 "6c3ee9bdb633b2b616f3fe0c3f4535a1c307d8c031deae0d90bfdbb447061fed"
  license "MIT"
  head "https://github.com/kattouf/ProgressLine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4261f2359e3299992684218d12146905f3a74b24c77e9da3d9ac7fb43a263f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cd9e5aa7f6599fde64b50d46e56a8798b2c2ac611de87f970c82fea287bb79d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3cb4c78994ff6ff3b0460cd9d30340874129774953ac83e91cb800c314e2e5d"
    sha256                               x86_64_linux:  "83a77fb6a7d99fb2a1483f855db990ed18f19ee0be86d78b7567f46fb8ded34e"
  end

  # requires Swift 5.10
  depends_on xcode: ["15.3", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/progressline"
  end

  test do
    some_command_multiline_output = "First line\nSecond line\nLast line"
    assert_match "✓ 0s ❯ Last line", pipe_output(bin/"progressline", some_command_multiline_output).chomp
  end
end
