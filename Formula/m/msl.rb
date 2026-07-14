class Msl < Formula
  desc "macOS Subsystem for Linux — run Arch Linux ARM via Virtualization.framework"
  homepage "https://github.com/xt9y/msl"
  url "https://github.com/xt9y/msl/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d81bae1d8cae7e6cf1fbf4842bf524e4772abd9ff43fa4595892963316a50cfa"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "make"
    bin.install "build/msl"
  end

  test do
    system bin/"msl", "--version"
  end
end
