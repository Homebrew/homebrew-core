class PlinkNg < Formula
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.6.32.tar.gz"
  version "2.0.0-a.6.32"
  sha256 "9d529d6fd5d1cf2893e36920db0b1ff4e6bad96fb9fa60a2ceee7b1e94dd8aab"
  license "LGPL-3.0-only"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  depends_on "openblas"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
   cd "2.0" do
      inreplace "build.sh", " -llapack -lcblas -lblas", "-L#{Formula["openblas"].opt_lib} -lopenblas" if OS.linux?
      system "./build.sh"
      bin.install "bin/plink2" => "plink2"
      bin.install "bin/pgen_compress" => "pgen_compress"
    end
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert_path_exists testpath/"dummy_cc1.pvar"
  end
end
