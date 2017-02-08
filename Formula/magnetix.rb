class Magnetix < Formula
  desc "Interpreter for Magnetic Scrolls adventures"
  homepage "http://www.maczentrisch.de/magnetiX/"
  url "http://www.maczentrisch.de/magnetiX/downloads/magnetiX_src.zip"
  version "3.1"
  sha256 "9862c95659c4db0c5cbe604163aefb503e48462c5769692010d8851d7b31c2fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee4c817c04ed86ac02db49790b3c04614e8e0910b3ca8e2919cd109cfc0af859" => :yosemite
    sha256 "77c8740e09b3653bceb2a346c7c6856ac0bd692c66c7499e2037e991376e536a" => :mavericks
    sha256 "06f295ba2960f8f374030cc0d75753ac8ff90c1497e86dc68f11d06646cdad74" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    cd "magnetiX_src" do
      xcodebuild
      prefix.install "build/Default/magnetiX.app"
      bin.write_exec_script "#{prefix}/magnetiX.app/Contents/MacOS/magnetiX"
    end
  end

  def caveats; <<-EOS.undent
    Install games in the following directory:
      ~/Library/Application Support/magnetiX/
    EOS
  end

  test do
    File.executable? "#{prefix}/magnetiX.app/Contents/MacOS/magnetiX"
  end
end
