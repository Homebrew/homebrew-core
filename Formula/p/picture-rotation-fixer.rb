class PictureRotationFixer < Formula
  desc "Effortlessly auto-rotate scanned photos to the correct orientation"
  homepage "https://github.com/JustinGuese/picture-rotation-fixer"
  version "0.0.6"

  on_macos do
    on_intel do
      url "https://github.com/JustinGuese/picture-rotation-fixer/releases/download/v0.0.6/picture-rotation-fixer-macos-x64"
      sha256 "b57fe78f98fe9316fbe12b4dc44f98977d7c4923a6886df252d1e888f9365dac"
    end

    on_arm do
      url "https://github.com/JustinGuese/picture-rotation-fixer/releases/download/v0.0.6/picture-rotation-fixer-macos-arm64"
      sha256 "97f48c88cf9ddf35cfbe9c5fc93fadf33193fa8c70241b09435390678a3eb76e"
    end
  end

  def install
    if Hardware::CPU.intel?
      bin.install "picture-rotation-fixer-macos-x64" => "picture-rotation-fixer"
    else
      bin.install "picture-rotation-fixer-macos-arm64" => "picture-rotation-fixer"
    end
    chmod 0755, bin/"picture-rotation-fixer"
  end

  test do
    system "#{bin}/picture-rotation-fixer", "--help"
  end
end
