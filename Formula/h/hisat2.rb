class Hisat2 < Formula
  include Language::Python::Shebang

  desc "Graph-based alignment to a population of genomes"
  homepage "https://daehwankimlab.github.io/hisat2/"
  url "https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "b53107422e5b44ebea4b20b1a77bb9e240d6b92d654fcd7e6a6ab5d1aae86c45"
  license "GPL-3.0-or-later"
  head "https://github.com/DaehwanKimLab/hisat2.git", branch: "master"

  depends_on "python@3.14"

  def install
    system "make"
    # Reject images so the glob does not pick up HISAT2*.png on
    # case-insensitive filesystems.
    bin.install "hisat2", Dir["hisat2-*"].grep_v(/\.png$/), Dir["hisat2_*.py"]
    bin.find { |f| rewrite_shebang detected_python_shebang, f }
    doc.install Dir["docs/*"]
    pkgshare.install "example", "scripts"
  end

  test do
    system bin/"hisat2-build", pkgshare/"example/reference/22_20-21M.fa", "genome_index"
    assert_path_exists testpath/"genome_index.1.ht2"

    output = shell_output("#{bin}/hisat2 -f -x genome_index " \
                          "-U #{pkgshare}/example/reads/reads_1.fa -S out.sam 2>&1")
    assert_match "100.00% overall alignment rate", output
    assert_match "SN:22:20000001-21000000", (testpath/"out.sam").read
  end
end
