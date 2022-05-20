class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/v1.0.10.tar.gz"
  sha256 "8fd43498988f6d334d483faf4e4a330a25228784995d72c57e4565967d09e6ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f7ff645731a8108b32f4aba84a8b501177c5a4de47d0a2c8db23b5119fd7c92"
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
