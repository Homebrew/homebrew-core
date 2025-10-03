class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https://github.com/kattouf/ProgressLine"
  url "https://github.com/kattouf/ProgressLine/archive/refs/tags/0.2.4.tar.gz"
  sha256 "6649fa7d9b840bf8af2ddef3819c6c99b883dd1e0ca349e6d8bdb93985cb00fa"
  license "MIT"
  head "https://github.com/kattouf/ProgressLine.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e82f5a1a3adf652f5e8bd8b6941507eb9fd2b995ec36fb5a673c66208c128d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045e5418e7f4e6b95b5466c1305de384ebe61c46751d945ab9b85e2eff18dd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4de062267b1d1ee13d97e9b1b9413f8eb6b921fb586a22ec35603de6bc3a799"
    sha256 cellar: :any,                 arm64_ventura: "0ae3e7443b2d0f26ca6a2707cc5190a8ec2e1a939076fdf4fdd319b37e13fca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e76d606b4aae24fc61ba66a3a4cc4014efe3390a1bd89f022546bdfaf4ca67"
    sha256 cellar: :any,                 ventura:       "b9d20a041aa6b083706306d87490f0f831d0747317037c912537ad50f37c2693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "826e2a32265a039262ed40703e99acbad76a8b4db2762b723a3baecdb997cbd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff927b499b1881aad2a4f5f0ce1bcc86c72b5b7fc34a0b85303a31928b124105"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/progressline"
    generate_completions_from_executable(bin/"progressline", "--generate-completion-script")
  end

  test do
    some_command_multiline_output = "First line\nSecond line\nLast line"
    assert_match "✓ 0s ❯ Last line", pipe_output(bin/"progressline", some_command_multiline_output).chomp
  end
end
