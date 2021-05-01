class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https://bioinf.uni-greifswald.de/augustus/"
  url "https://github.com/Gaius-Augustus/Augustus/releases/download/v3.3.3/augustus-3.3.3.tar.gz"
  sha256 "4cc4d32074b18a8b7f853ebaa7c9bef80083b38277f8afb4d33c755be66b7140"
  license "Artistic-1.0"
  revision 2
  head "https://github.com/Gaius-Augustus/Augustus.git"

  livecheck do
    url "https://bioinf.uni-greifswald.de/augustus/binaries/"
    regex(/href=.*?augustus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "84b334a9bcb3b3fe938616771ea4c845b930f25250c562601f2b2101f35323d8"
    sha256 cellar: :any, big_sur:       "913e41174da9fae9e1103e74f0afec17f5c6b142a9eeae02062e92b01a7cc244"
    sha256 cellar: :any, catalina:      "06d0cd1799273e82170582c51f164f7766e56b7110056a9daec94a988de5866d"
    sha256 cellar: :any, mojave:        "fcc26d38b47776cab3c03193fff49df975d1de141743503753926b861abdea80"
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
      on_macos do
        # Clang breaks proteinprofile on macOS. This issue has been first reported
        # to upstream in 2016 (see https://github.com/nextgenusfs/funannotate/issues/3).
        # See also https://github.com/Gaius-Augustus/Augustus/issues/64
        gcc_major_ver = Formula["gcc"].any_installed_version.major
        with_env("HOMEBREW_CC" => Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}") do
          system "make"
        end
      end
      on_linux do
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
