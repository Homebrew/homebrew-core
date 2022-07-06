class Bun < Formula
  desc "Bun is a fast all-in-one JavaScript runtime"
  homepage "https://bun.sh"
  url "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/latest/download/bun-linux-x64.zip"
  sha256 "51c04d71627bf99868527f6a00397aba8bc013a90e1ef1a02080a4e93d291c0d"
  license "MIT"

  def install
    bin.install "bun"
  end

  test do
    system "false"
  end
end
