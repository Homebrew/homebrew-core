class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/v6.3.0.tar.gz"
  sha256 "4e1bbbde6e5ccf9d766ffd80c8f6d232f5a4904b63e0b7102396d2766ab486ce"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git"

  depends_on "go"

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/counterfeiter -p os 2>&1", 1)
    assert_match "Writing `Os` to `osshim`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
