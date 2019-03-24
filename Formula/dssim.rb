class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/2.10.0.tar.gz"
  sha256 "1bc9abec552fc64d3951340d95f68212d30e6473a93694db25cf16a0baa9d854"

  bottle do
    sha256 "1f55ff853a5eb098b10d381cc64cad2b2a79bf5b417d5fafbc7ca1ce9531a0f7" => :mojave
    sha256 "cd9660967e876f49480ae7f8f1486ebd7f752edf2a22621b03f2b6bc8bf07f73" => :high_sierra
    sha256 "923949599d0070fbe2c6938f5847ed6df69097921897ce118d7e9cc8ef48cb40" => :sierra
    sha256 "34f0204a20f42a08c375b831669e8fdf8b2a8e54a77298f5c35a75403b1c69c7" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
