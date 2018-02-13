class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.7.1+-src.tar.gz"
  mirror "ftp://ftp.hgc.jp/pub/mirror/ncbi/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-src.tar.gz"
  version "2.7.1"
  sha256 "10a78d3007413a6d4c983d2acbf03ef84b622b82bd9a59c6bd9fbdde9d0298ca"

  bottle do
    sha256 "8d21490761a54f139a503886e2323cc0b8787b4c53d97b0b6db3a3272be2a22f" => :high_sierra
    sha256 "de7ffc542448f52cb3530f9e2249b6b33119484b252f19a659056650de21c0d0" => :sierra
    sha256 "923382e15b9ece9d81579fc8791f680d450826cbefcad7eda0d3c3fae40682a6" => :el_capitan
  end

  option "with-static", "Build without static libraries and binaries"
  option "with-dll", "Build dynamic libraries"

  depends_on "freetype" => :optional
  depends_on "gnutls" => :optional
  depends_on "hdf5" => :optional
  depends_on "lzo" => :optional
  depends_on "mysql" => :optional
  depends_on "pcre" => :recommended
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    # Use ./configure --without-boost to fix
    # error: allocating an object of abstract class type 'ncbi::CNcbiBoostLogger'
    # Boost is used only for unit tests.
    # See https://github.com/Homebrew/homebrew-science/pull/3537#issuecomment-220136266
    # The build invokes datatool but its linked libraries aren't installed yet.
    # The libraries and headers conflict with ncbi-c++-toolkit so use libexec.
    args = %W[
      --prefix=#{prefix}
      --libdir=#{libexec}
      --without-debug
      --with-mt
      --without-boost
    ]

    args << (build.with?("mysql") ? "--with-mysql" : "--without-mysql")
    args << (build.with?("freetype") ? "--with-freetype=#{Formula["freetype"].opt_prefix}" : "--without-freetype")
    args << (build.with?("gnutls") ? "--with-gnutls=#{Formula["gnutls"].opt_prefix}" : "--without-gnutls")
    args << (build.with?("pcre")   ? "--with-pcre=#{Formula["pcre"].opt_prefix}" : "--without-pcre")
    args << (build.with?("hdf5")   ? "--with-hdf5=#{Formula["hdf5"].opt_prefix}" : "--without-hdf5")

    if build.without? "static"
      args << "--with-dll" << "--without-static" << "--without-static-exe"
    else
      args << "--with-static"
      args << "--with-static-exe" unless OS.linux?
      args << "--with-dll" if build.with? "dll"
    end

    cd "c++" do
      ln_s buildpath/"c++/ReleaseMT/lib", prefix/"libexec" if build.without? "static"
  
      system "./configure", *args
      system "make"
  
      rm prefix/"libexec" if build.without? "static"
  
      system "make", "install"
  
      # The libraries and headers conflict with ncbi-c++-toolkit.
      libexec.install include
    end
  end

  def caveats; <<-EOS
    Using the option "--with-static" will create static binaries instead of
    dynamic. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.
    Static binaries should be used for speed if the executable requires fast
    startup time, such as if another program is frequently restarting the blast
    executables.
    EOS
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end
