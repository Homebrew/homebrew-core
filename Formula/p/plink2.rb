class Plink2 < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.00a5.12.tar.gz"
  version "2.00a5.12"
  sha256 "bf55f172c709265c9c7bf1518bb4f0036d28fecdd7b17f8db7f9d106586bb3f5"
  license "GPL-3.0-or-later"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  def install
    cd "2.0" do
      if OS.linux?
        inreplace "build.sh", " -llapack -lcblas -lblas",
                  "-L#{formula_opt_lib("openblas")} -lopenblas"
      end
      system "./build.sh"
      bin.install "bin/plink2", "bin/pgen_compress"
    end
  end

  test do
    system bin/"plink2", "--dummy", "100", "200", "--out", "dummy"
    assert_path_exists testpath/"dummy.pvar"
  end
end
