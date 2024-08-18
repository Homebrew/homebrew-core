class Kalonys < Formula
  desc "Kalonys CLI"
  homepage "https://kalonys.fr"
  url "https://kalonys-cli-artifacts.s3.amazonaws.com/kalonys-mac-1.0.1"
  sha256 "e44077feffe62d40b7d31c190df61672217634e796be918273d6b1c6c79322b8"
  version "1.0.1"

  def install
    bin.install "kalonys-mac" => "kalonys"
  end

  test do
    system "#{bin}/kalonys", "--version"
  end
end
