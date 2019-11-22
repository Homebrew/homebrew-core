class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/releases/download/v3.3.3/augustus-3.3.3.tar.gz"
  sha256 "4cc4d32074b18a8b7f853ebaa7c9bef80083b38277f8afb4d33c755be66b7140"
  head "https://github.com/Gaius-Augustus/Augustus.git"

  bottle do
    cellar :any
    sha256 "397da54388ec9d56ee891b021fe313e0e4cfa2e46e80ef177ddd6d24723abec3" => :catalina
    sha256 "67298cd2aa811dfa953f8d0c9019df12fe2f7aec6cd35ebf1cf27e38fb39e858" => :mojave
    sha256 "030d9fced4d6863a77e5058f145e2d13560ef0b9aedd1cb01e96c593c9e3cbc6" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "bamtools"
  depends_on "gcc"

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

    # Clang breaks proteinprofile on macOS. This issue has been first reported
    # to upstream in 2016 (see https://github.com/nextgenusfs/funannotate/issues/3).
    # See also https://github.com/Gaius-Augustus/Augustus/issues/64
    cd "src" do
      with_env("HOMEBREW_CC" => "gcc-9") do
        system "make"
      end
    end

    system "make"
    system "make", "install", "INSTALLDIR=#{prefix}"
    bin.env_script_all_files libexec/"bin", :AUGUSTUS_CONFIG_PATH => prefix/"config"
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}/augustus --species=human test.fasta"
    assert_match "Predicted genes", shell_output(cmd)

    cp pkgshare/"examples/example.fa", testpath
    cp pkgshare/"examples/profile/HsDHC.prfl", testpath
    cmd = "#{bin}/augustus --species=human --proteinprofile=HsDHC.prfl example.fa 2> /dev/null"
    assert_match "HS04636	AUGUSTUS	gene	966	6903	1	+	.	g1", shell_output(cmd)
  end
end
