class Buildcannon < Formula
  desc "buildcannon is a terminal automation buildtool for iOS"
  homepage "https://github.com/andersonlucasg3/buildcannon"
  url "https://github.com/andersonlucasg3/buildcannon/releases/download/0.2.0/buildcannon.zip"
  sha256 "a8a28eaacc67abf557f4437588137fa932f45bc2466883ead1b4775529655190"
  
  def install
    bin.install "buildcannon"
  end

  def test
    system "#{bin}/buildcannon", "--help"
  end
end
