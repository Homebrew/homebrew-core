class Dssim < Formula
  desc "RGBA Structural Similarity C implementation (with a Rust API)"
  homepage "https://github.com/pornel/dssim"
  url "https://github.com/pornel/dssim/archive/1.1.tar.gz"
  sha256 "bad5bde3846e499be16e551248168b98195ca1e5893f948739ecc0cf2e8d52f6"

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make"
    bin.install Dir["bin/*"]
  end

  test do
    system "false"
  end
end
