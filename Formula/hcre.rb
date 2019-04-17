class Hcre < Formula
  desc "Brew tap of Hashcat's Rule Engine"
  homepage "https://github.com/Viltaria/homebrew-hcre"
  url "https://github.com/Viltaria/homebrew-hcre/raw/master/archive/hcre-1.0.0.tar.gz"
  sha256 "3bf42f2b407f3cb6540fba2b2168e0b585313d63e4ddd4d4665fa042003e0011"

  bottle :unneeded

  depends_on "gcc"

  def install
    bin.install "hcre"
  end

  test do
    system "#{bin}/hcre"
  end
end
