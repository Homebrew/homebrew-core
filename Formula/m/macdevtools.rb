# Homebrew Formula for MacDevTools
# Save this file as: homebrew-tap/Formula/macdevtools.rb

class Macdevtools < Formula
  desc "macOS Terminal Toolkit - All-in-One System Maintenance & Development Tools"
  homepage "https://github.com/khakhasshi/MacDevTools"
  url "https://github.com/khakhasshi/MacDevTools/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6b59d0c416f2fb2006f9b4fb9f19ea3d1207d583cdf565410b8db71e6200a8f4"
  license "MIT"

  def install
    libexec.install Dir["*.sh"]
    libexec.install "tool"
    bin.install_symlink libexec/"tool"
  end

  test do
    system "#{bin}/tool", "help"
  end
end
