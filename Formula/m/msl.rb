class Msl < Formula
  desc "macOS Subsystem for Linux — run Arch Linux ARM via Virtualization.framework"
  homepage "https://github.com/xt9y/msl"
  url "https://github.com/xt9y/msl/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "95289fd0d16d9158184df1879af7bc52a072e425a03514dff8227ac100912103"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "make"
    bin.install "build/msl"
  end

  test do
    system "#{bin}/msl", "--version"
  end
end
