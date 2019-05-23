class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.3.2.tar.gz"
  sha256 "989a95fe3a83d62af4d323a9727d11b2c566adcf4d789d5d86d7b842d83e7671"
  head "https://github.com/Gaius-Augustus/Augustus.git"

  bottle do
    sha256 "2d7449f08dbf38ee7a46d51e2f17032221b0567e4a215e7d309602cee8724ce5" => :mojave
    sha256 "6df315ec1bad28e6708e8a99b533216de4c4049ef1e79680f4132e77209f77b5" => :high_sierra
    sha256 "020e9e8531aeaad48d06a96ca78eda64eae25e3737e69941f9069e6abd4e898d" => :sierra
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
