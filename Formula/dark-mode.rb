class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/v3.0.1.tar.gz"
  sha256 "408a8ed20ce045a7fc29120edb9d9248dec09c81d1a1883c36c7de43fbe3369f"
  license "MIT"
  head "https://github.com/sindresorhus/dark-mode.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f55ca33ba8a81afb01c168743c8ecad337af15d883822acd9982729b2a129bcb"
    sha256 cellar: :any_skip_relocation, catalina: "b9ce8876210cccd70e87ed5781a313f4b2705330453cd4af7ff2474f659d184e"
    sha256 cellar: :any_skip_relocation, mojave:   "bfb3cbcc43a333d6ca8ef8c52c89dc6d0cc23938f4e4fbd6ac13683e4ad63bd6"
  end

  depends_on xcode: :build
  depends_on macos: :mojave

  def install
    system "./build"
    bin.install "bin/dark-mode"
  end

  test do
    system "#{bin}/dark-mode", "--version"
  end
end
