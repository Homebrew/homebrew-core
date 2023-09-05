class Ipcalc < Formula
  desc "Calculate various network masks, etc. from a given IP address"
  homepage "http://jodies.de/ipcalc"
  url "https://github.com/kjokjo/ipcalc/archive/0.51.tar.gz"
  sha256 "a4dbfaeb7511b81830793ab9936bae9d7b1b561ad33e29106faaaf97ba1c117e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5152662bf61c4a00cb8fde98f1f0ac84a5b4f8e5b652fd4e2f88277e76a60671"
  end

  def install
    bin.install "ipcalc"
  end

  test do
    system "#{bin}/ipcalc", "--nobinary", "192.168.0.1/24"
  end
end
