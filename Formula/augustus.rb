class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.3.2.tar.gz"
  sha256 "989a95fe3a83d62af4d323a9727d11b2c566adcf4d789d5d86d7b842d83e7671"

  bottle do
    sha256 "0017873906f79182fe69668e5652d0c837e867b847f5abde31678c5bee915369" => :mojave
    sha256 "8ddcf0271ba6204c052ee9cb0d7e71fc68a2e5351e1b3dd6f09e74d6962fa1c3" => :high_sierra
    sha256 "79f8c3a53d545cd2be18e2581e8d66bb83f3643a2eb4a62553f24000c4c50f81" => :sierra
    sha256 "b8fd08dcad3d8a29d2615076a6a3603cfcec6526524db18269df7c62a8925e8e" => :el_capitan
  end

  depends_on "bamtools"
  depends_on "boost"

  def install
    # Avoid "fatal error: 'sam.h' file not found" by not building bam2wig
    inreplace "auxprogs/Makefile", "cd bam2wig; make;", "#cd bam2wig; make;"

    # Fix error: api/BamReader.h: No such file or directory
    inreplace "auxprogs/bam2hints/Makefile",
      "INCLUDES = /usr/include/bamtools",
      "INCLUDES = #{Formula["bamtools"].include/"bamtools"}"
    inreplace "auxprogs/filterBam/src/Makefile",
      "BAMTOOLS = /usr/include/bamtools",
      "BAMTOOLS= #{Formula["bamtools"].include/"bamtools"}"

    # Prevent symlinking into /usr/local/bin/
    inreplace "Makefile", %r{ln -sf.*/usr/local/bin/}, "#ln -sf"

    # Compile executables for macOS. Tarball ships with executables for Linux.
    system "make", "clean"
    system "make"

    system "make", "install", "INSTALLDIR=#{prefix}"
    bin.env_script_all_files libexec/"bin", :AUGUSTUS_CONFIG_PATH => prefix/"config"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}/augustus --species=human test.fasta"
    assert_match "Predicted genes", shell_output(cmd)
  end
end
