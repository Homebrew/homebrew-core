class Hyeong < Formula
  desc "Hyeo-ung Programming Language Compiler in Rust (beta release)"
  homepage "https://github.com/buttercrab/hyeo-ung-lang"
  version "0.1.0"

  url "https://github.com/buttercrab/hyeo-ung-lang/releases/download/v#{version}/hyeong-#{version}-darwin-x86-64.tar.gz"
  sha256 "24990f87afe0813a0d67ba6525bc822b73f470c58692b5eedcdb5203dec2aa63"

  def install
    bin.install "hyeong"
  end

  test do
    assert_match "hyeong 0.1.0", shell_output("#{bin}/hyeong --version")
  end
end

