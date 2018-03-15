class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/2.9.7.tar.gz"
  sha256 "4ee60e125efae43f49bf9c4ca849f9cef2b1f86ee1d538da84907faae853eeeb"

  bottle do
    sha256 "cd9660967e876f49480ae7f8f1486ebd7f752edf2a22621b03f2b6bc8bf07f73" => :high_sierra
    sha256 "923949599d0070fbe2c6938f5847ed6df69097921897ce118d7e9cc8ef48cb40" => :sierra
    sha256 "34f0204a20f42a08c375b831669e8fdf8b2a8e54a77298f5c35a75403b1c69c7" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
