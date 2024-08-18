class Kalonys < Formula
  desc "Kalonys CLI"
  homepage "https://kalonys.fr"
  url "https://kalonys-cli-artifacts.s3.amazonaws.com/kalonys-mac-1.0.2"
  sha256 "cce786e542049308d5a249616cb5a1c46938cc5cb3775939079be3403a638838"
  version "1.0.2"

  def install
    bin.install "kalonys-mac" => "kalonys"
  end

  test do
    system "#{bin}/kalonys", "--version"
  end
end
