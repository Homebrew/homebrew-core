class Hyeong < Formula
  desc "Hyeo-ung Programming Language Compiler in Rust (beta release)"
  homepage "https://github.com/buttercrab/hyeo-ung-lang"
  version "0.1.0"

  if OS.mac?
    url "https://github.com/buttercrab/hyeo-ung-lang/releases/download/v#{version}/hyeong-#{version}-darwin-x86-64.tar.gz"
    sha256 "24990f87afe0813a0d67ba6525bc822b73f470c58692b5eedcdb5203dec2aa63"
  elsif OS.linux?
    url "https://github.com/buttercrab/hyeo-ung-lang/releases/download/v#{version}/hyeong-#{version}-linux-x86-64.tar.gz"
    sha256 "82ede138f347af3034a4c2b3efd84393ec60acd33af77f209cd59e4afb74fe98"
  end

  def install
    bin.install "hyeong"
  end

  test do
    assert_match "hyeong 0.1.0", shell_output("#{bin}/hyeong --version")
  end
end

