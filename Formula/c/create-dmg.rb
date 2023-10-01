class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "434746a84ed7e4a04b1d1977503e2a23ff79dac480cb86b24aae7b112e3b7524"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1d0ce1a3da65fb140ef2740dd778066c9f26122f5fb58fd64f4200bb168fc85"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
