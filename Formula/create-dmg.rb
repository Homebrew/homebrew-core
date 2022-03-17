class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/v1.0.10.tar.gz"
  sha256 "8fd43498988f6d334d483faf4e4a330a25228784995d72c57e4565967d09e6ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbbb2e726579852cfa16abe27bc34bf78a2df0c991a9d9d6994c2ffbd5c2773d"
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
