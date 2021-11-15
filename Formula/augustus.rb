class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/releases/download/v3.3.3/augustus-3.3.3.tar.gz"
  sha256 "4cc4d32074b18a8b7f853ebaa7c9bef80083b38277f8afb4d33c755be66b7140"
  license "Artistic-1.0"
  revision 2
  head "https://github.com/Gaius-Augustus/Augustus.git", branch: "master"

  livecheck do
    url "https://bioinf.uni-greifswald.de/augustus/binaries/"
    regex(/href=.*?augustus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "cf98b0583590e5c5c83bcae8357d9a510c18240b33b12c9f95ca4ec0318d61f4"
    sha256 cellar: :any,                 monterey:      "d5346659a287d591d36110f987ae3becb64ab8d63cb940aaea46d68439208be4"
    sha256 cellar: :any,                 big_sur:       "0ceda121d6ead1c2b3812f7e1a9155366751da603fd1ab6c0ccbcada6eebb668"
    sha256 cellar: :any,                 catalina:      "526462eb67bf51a1b95fdecf402d67df75c876333adfabe5aedffe89d76946fc"
    sha256 cellar: :any,                 mojave:        "1eab0e15ac3027334f0ccda5e4edce2d99cafeffcea50f486842aada76bf6212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8271784fc43729dd82e83e031ef63bb278771c6ba271ff7c7bc17908abc56646"
  end

  depends_on "boost" => :build
  depends_on "bamtools"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc"
  end

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

    cd "src" do
      if OS.mac?
        # Clang breaks proteinprofile on macOS. This issue has been first reported
        # to upstream in 2016 (see https://github.com/nextgenusfs/funannotate/issues/3).
        # See also https://github.com/Gaius-Augustus/Augustus/issues/64
        gcc_major_ver = Formula["gcc"].any_installed_version.major
        with_env("HOMEBREW_CC" => Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}") do
          system "make"
        end
      else
        system "make"
      end
    end

    system "make"
    system "make", "install", "INSTALLDIR=#{prefix}"
    bin.env_script_all_files libexec/"bin", AUGUSTUS_CONFIG_PATH: prefix/"config"
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
