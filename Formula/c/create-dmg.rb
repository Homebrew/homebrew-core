class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/v1.1.0.tar.gz"
  sha256 "d50e14a00b73a3f040732b4cfa11361f5786521719059ce2dfcccd9088d3bf32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5e0bef6c032eb5a47e84887ac1f04e48441f9056144169a2bfdf32e94adf4a3"
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
