class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "18e8dd7db06c9d6fb590c7877e1714b79b709f17d1d138bd65e4910cc82391bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed92cefd6df282057e6c1a162eb453d4c8d3b34a4a8637bf292813817badef81"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system bin/"create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
