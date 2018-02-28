class Elastix < Formula
  desc "Toolbox for rigid and nonrigid registration of images"
  homepage "http://elastix.isi.uu.nl/index.php"
  url "http://elastix.isi.uu.nl/download/elastix_macosx64_v4.8.zip"
  sha256 "d9c49856674e7f39619b3dbbf85e6a9a902c660f9b68e37a9a7e381ebda9d29b"

  def install
    prefix.install "LICENSE", "NOTICE", "bin", "lib"
  end

  test do
    system "false"
  end
end
