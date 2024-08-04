class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https://github.com/kattouf/ProgressLine"
  url "https://github.com/kattouf/ProgressLine/archive/refs/tags/0.2.1.tar.gz"
  sha256 "5ad7ff2b766f59b25f0e197e25b728e1272dc38fd3bd377480e8212f6e03abad"
  license "MIT"
  head "https://github.com/kattouf/ProgressLine.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "e2242b4412917ecaeda120ad2e4d5919f24277e23b0f2f52d9d5fc169fb248ad"
  end

  depends_on xcode: ["15.4", :build]

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
