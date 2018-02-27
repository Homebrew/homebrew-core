class Fasttext < Formula
  desc "Library for fast text representation and classification"
  homepage "https://github.com/facebookresearch/fastText"
  url "https://github.com/facebookresearch/fastText/archive/v0.1.0.tar.gz"
  sha256 "d6b4932b18d2c8b3d50905028671aadcd212b7aa31cbc6dd6cac66db2eff1397"
  head "https://github.com/facebookresearch/fastText.git"

  def install
    system "make"
    bin.install "fasttext"
  end

  test do
    system "true"
  end
end
