class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https://wiki.debian.org/Apt"
  url "https://deb.debian.org/debian/pool/main/a/apt/apt_2.4.2.tar.xz"
  sha256 "03676af4199b4a16be63ff4bc47179510810ebe520fd4f11648157c18e198566"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/a/apt/"
    regex(/href=.*?apt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "2ebc77a62072a2440b735b49f677c2b0a1cd35a762c4b124bb52fb5785b5939a"
  end

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "googletest" => :build
  depends_on "libxslt" => :build
  depends_on "po4a" => :build
  depends_on "w3m" => :build

  depends_on "berkeley-db"
  depends_on "bzip2"
  depends_on "dpkg"
  depends_on "gcc"
  depends_on "gettext"
  depends_on "gnupg"
  depends_on "gnutls"
  depends_on :linux
  depends_on "lz4"
  depends_on "perl"
  depends_on "xxhash"
  depends_on "zlib"

  on_linux do
    keg_only "not linked to prevent conflicts with system apt"
  end

  fails_with gcc: "5"

  resource "SGMLS" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz"
    sha256 "550c9245291c8df2242f7e88f7921a0f636c7eec92c644418e7d89cfea70b2bd"
  end

  resource "triehash" do
    url "https://github.com/julian-klode/triehash/archive/v0.3.tar.gz"
    sha256 "289a0966c02c2008cd263d3913a8e3c84c97b8ded3e08373d63a382c71d2199c"
  end

  resource "Unicode::GCString" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  resource "Text::WrapI18N" do
    url "https://cpan.metacpan.org/authors/id/K/KU/KUBOTA/Text-WrapI18N-0.06.tar.gz"
    sha256 "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
    sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
  end

  resource "Pod::Parser" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz"
    sha256 "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
    ENV.prepend_path "PERL5LIB", buildpath/"lib"
    ENV.prepend_path "PATH", buildpath/"bin"

    resource("triehash").stage do
      (buildpath/"bin").install "triehash.pl" => "triehash"
    end

    cpan_resources = resources.map(&:name).to_set - ["triehash"]
    cpan_resources.each do |r|
      resource(r).stage do
        chmod 0644, "MYMETA.yml" if r == "SGMLS"
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make"
        system "make", "install"
      end
    end

    mkdir "build" do
      system "cmake", "..",
             "-DDPKG_DATADIR=#{Formula["dpkg"].opt_libexec}/share/dpkg",
             "-DDOCBOOK_XSL=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
             "-DBERKELEY_INCLUDE_DIRS=#{Formula["berkeley-db"].opt_include}",
             *std_cmake_args
      system "make", "install"
    end

    mkdir_p etc/"apt/apt.conf.d/"
  end

  test do
    assert_match "The package lists or status file could not be parsed or opened.",
      shell_output("#{bin}/apt list 2>&1", 100)
  end
end
