class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.3.tar.gz"
  sha256 "b5eb811a4c33a2cc3bbd16355e19d530eeac6d1ac923e59f48d7a79f396234ee"
  revision 1

  bottle do
    sha256 "6ffeac4edd4805321ea0957959f85da8cc1f5978cdc8a98903a78c407d5d183e" => :high_sierra
    sha256 "b87f6e5824186aaa1a02cc6665dde1328a4255aed653de85edd3e4bd40f65c60" => :sierra
    sha256 "19a761ef4afa0cd5e9699b59b11eaac2e7e1d3dbfa14e2c8ced1b27eb57c2c1e" => :el_capitan
  end

  depends_on "bamtools"
  depends_on "boost"

  def install
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
