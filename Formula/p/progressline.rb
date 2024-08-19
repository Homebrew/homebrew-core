class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https://github.com/kattouf/ProgressLine"
  url "https://github.com/kattouf/ProgressLine/archive/refs/tags/0.2.1.tar.gz"
  sha256 "5ad7ff2b766f59b25f0e197e25b728e1272dc38fd3bd377480e8212f6e03abad"
  license "MIT"
  head "https://github.com/kattouf/ProgressLine.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f41428e7de9c5f3d81cde301ebf374fa8e5122224dd37d966219f7694a757a8e"
    sha256 cellar: :any_skip_relocation, sonoma:       "89b0b2bff1f412f80a95381688565e84fa538fb9ec5c38921280151a24aa34d5"
    sha256                               x86_64_linux: "f34c2797c76a7385bf4f23a6a6a6d8d146b9243734cd63698e1ed49c80a12e57"
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
