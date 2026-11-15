class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.17.0/ncbi-blast-2.17.0+-src.tar.gz"
  version "2.17.0"
  sha256 "502057a88e9990e34e62758be21ea474cc0ad68d6a63a2e37b2372af1e5ea147"
  license :public_domain
  revision 2

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_golden_gate: "5db429964b697b4d39c1323366522f675b780c8577087042edb62a4091aad0b3"
    sha256 arm64_tahoe:       "c4b40232e3ae04bad85618d2a855b75e58059878e7c0ded5a327f7ab3e070af7"
    sha256 arm64_sequoia:     "c653cb7d6f812f794a5496c9c7c4e1fdfa2fe600263294cfbf38dc6a4a6b5ade"
    sha256 arm64_sonoma:      "fbca1a7dac99eb6600ed29ae4a5071263b4239ae5d127afc52016ccca0994023"
    sha256 arm64_linux:       "7515cbd0a555a55262fd7021eb4001d573f39362ccecf34c5476fbb117809552"
    sha256 x86_64_linux:      "969d1e7c127e73ba543b86cb5515cb1aee569b85a1742fdff57a3a54ba3b5a4b"
  end

  deprecate! date: "2027-03-31", because: "needs EOL `mbedtls@3`"

  depends_on "lmdb"
  depends_on "mbedtls@3"
  depends_on "pcre2"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "proj", because: "both install a `libproj.a` library"

  # Apply Debian patch to remove version check on the compile-time TLS library
  # patch version. This avoids unnecessary rebuilds across ABI-compatible updates.
  # The alternative is to use the bundled copy which isn't ideal for a TLS library.
  patch do
    url "https://salsa.debian.org/med-team/ncbi-blastplus/-/raw/81bb56c0d709fd571c9b99958b6651fed5a13dcd/debian/patches/suppress_tls_version_checks"
    sha256 "35f3e916762129a2b48d78e1c5f15e6108fe7e5525e3e0c605c5ca7882000f6e"
    type :unofficial
  end

  allow_network_access! :test

  def install
    cd "c++" do
      # Remove bundled libraries to make sure the brew/system libraries are used
      %w[compress/bzip2 compress/zlib lmdb regexp].each do |lib_subdir|
        rm_r("include/util/#{lib_subdir}") if lib_subdir != "regexp"
        rm_r("src/util/#{lib_subdir}")
      end
      rm_r(Dir["include/util/regexp/*"] - ["include/util/regexp/ctre"])
      rm_r("src/connect/mbedtls")

      # Remove Cloudflare zlib on arm64 linux as it requires a minimum of armv8-a+crc
      # TODO: re-enable if we increase our minimum march to require crc
      if Hardware::CPU.arm? && OS.linux?
        rm_r("include/util/compress/zlib_cloudflare")
        rm_r("src/util/compress/zlib_cloudflare")

        zcf_files = ["src/build-system/Makefile.mk.in", "src/util/compress/api/Makefile.compress.lib"]
        inreplace zcf_files, /(=.*) zcf(\s)/, "\\1\\2"
      end

      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --with-bin-release
        --with-dll
        --with-mbedtls=#{formula_opt_prefix("mbedtls@3")}
        --with-mt
        --with-pcre2=#{formula_opt_prefix("pcre2")}
        --without-strip
        --with-experimental=Int8GI
        --without-debug
        --without-boost
        --without-internal
      ]
      args += ["OPENMP_FLAGS=-Xpreprocessor -fopenmp", "LDFLAGS=-lomp"] if OS.mac?

      system "./configure", *args
      # Fix the error: install: ReleaseMT/lib/*.*: No such file or directory
      system "make"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/update_blastdb.pl --showall")
    assert_match "nt", output

    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output

    # Create BLAST database
    output = shell_output("#{bin}/makeblastdb -in test.fasta -out testdb -dbtype nucl")
    assert_match "Adding sequences from FASTA", output

    # Check newly created BLAST database
    output = shell_output("#{bin}/blastdbcmd -info -db testdb")
    assert_match "Database: test", output
  end
end
