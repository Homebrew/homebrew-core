class Kalonys < Formula
  desc "CLI Tools to administrate Kalonys services"
  homepage "https://kalonys.fr"
  url "https://kalonys-cli-artifacts.s3.amazonaws.com/kalonys-mac-1.0.2"
  version "1.0.2"
  sha256 "2bf0c94692e13f8366a9a4697ac2745b0f38acd261bb95b88dcd6b58a2cbf54a"

  def install
    bin.install "kalonys-mac" => "kalonys"
  end

  test do
    system "#{bin}/kalonys", "--version"
  end
end
