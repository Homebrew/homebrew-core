class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 5
  head "https://github.com/bioperl/bioperl-live.git", branch: "master"

  # We specifically match versions with three numeric parts because upstream
  # documentation mentions that release versions have three parts and there are
  # older tarballs with fewer than three parts that we need to omit for version
  # comparison to work correctly.
  livecheck do
    url :stable
    regex(/href=["']?BioPerl[._-]v?(\d+\.\d+\.\d+)(?:\.?_\d+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "293417ccf86c9a0c7cbba6ea6f3074ca6d54b0ae9b192a85e57c0500eaae8b74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17556c5bf70068e4e7bf489bc486076f76304648c7fdda955138f305c751420a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7095b993a428c044b7722b4c4b52b8bf9ed46804dfd0b4625175eb02d7b7a7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "519a9359035523356d8bc712280715dc21337d4c987360f769f1d6255e2278a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfce7db6b21fd7ef9139acb05f5c740aafe7cabde5e582a9b243eda8c66288a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d791346056696397c1a244a097a2c1d3cfaa1be0a194c6c8e2d18fbc142a8e4"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "perl"

  on_macos do
    resource "XML::DOM" do
      url "https://cpan.metacpan.org/authors/id/T/TJ/TJMATHER/XML-DOM-1.46.tar.gz"
      sha256 "8ba24b0b459b01d6c5e5b0408829c7d5dfe47ff79b3548c813759048099b175e"
    end

    resource "XML::RegExp" do
      url "https://cpan.metacpan.org/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz"
      sha256 "df1990096036085c8e2d45904fe180f82bfed40f1a7e05243f334ea10090fc54"
    end

    resource "XML::Parser::PerlSAX" do
      url "https://cpan.metacpan.org/authors/id/K/KM/KMACLEOD/libxml-perl-0.08.tar.gz"
      sha256 "4571059b7b5d48b7ce52b01389e95d798bf5cf2020523c153ff27b498153c9cb"
    end

    resource "IPC::Run" do
      url "https://cpan.metacpan.org/authors/id/N/NJ/NJM/IPC-Run-20250809.0.tar.gz"
      sha256 "b1e85a30405786ed8378b68dd57159315ad7ddc0a55e432aa9eeca6166ca53fe"
    end

    resource "XML::Twig" do
      url "https://cpan.metacpan.org/authors/id/M/MI/MIROD/XML-Twig-3.54.tar.gz"
      sha256 "0b744a9737a070f95c32154afd526bf5ebe76a59feb8bc1f5dbc6cdaa5e0e529"
    end

    resource "Data::Stag" do
      url "https://cpan.metacpan.org/authors/id/C/CM/CMUNGALL/Data-Stag-0.14.tar.gz"
      sha256 "4ab122508d2fb86d171a15f4006e5cf896d5facfa65219c0b243a89906258e59"
    end

    resource "Graph::Directed" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Graph-0.9735.tar.gz"
      sha256 "5c9a51f89efe7a36db288590bf66753f2417afd41b82363e39f2f3101d498065"
    end

    resource "Heap" do
      url "https://cpan.metacpan.org/authors/id/J/JM/JMM/Heap-0.80.tar.gz"
      sha256 "ccda29f3c93176ad0fdfff4dd6f5e4ac90b370cba4b028386b7343bf64139bde"
    end

    resource "Set::Object" do
      url "https://cpan.metacpan.org/authors/id/R/RU/RURBAN/Set-Object-1.43.tar.gz"
      sha256 "e3b3c7c7ecb91ef6d20eb06bf6bff74e41c40b75bd234e107d2ecf78d3dea9d1"
    end

    resource "XML::SAX::Writer" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.57.tar.gz"
      sha256 "3d61d07ef43b0126f5b4de4f415a256fa859fa88dc4fdabaad70b7be7c682cf0"
    end

    resource "XML::Filter::BufferText" do
      url "https://cpan.metacpan.org/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz"
      sha256 "8fd2126d3beec554df852919f4739e689202cbba6a17506e9b66ea165841a75c"
    end

    resource "Set::Scalar" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz"
      sha256 "a3dc1526f3dde72d3c64ea00007b86ce608cdcd93567cf6e6e42dc10fdc4511d"
    end
  end

  on_linux do
    # Linux dependencies are complicated so keeping cpanminus until we provide
    # support for `brew update-perl-resources` or upstream reduces dependencies:
    # Issue ref: https://github.com/bioperl/bioperl-live/issues/314
    depends_on "cpanminus" => :build
  end

  def install
    ENV["ALIEN_INSTALL_TYPE"] = "system"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    if OS.mac?
      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "install"
        end
      end
    else
      system "cpanm", "--notest", "--self-contained", "--local-lib", libexec, "DBI"
      system "cpanm", "--notest", "--self-contained", "--local-lib", libexec, "--installdeps", "."
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLSITESCRIPT=#{bin}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    (testpath/"test.fa").write ">homebrew\ncattaaatggaataacgcgaatgg"
    assert_match ">homebrew\nH*ME*REW", shell_output("#{bin}/bp_translate_seq < test.fa")
    assert_match(/>homebrew-100_percent-1\n[atg]/, shell_output("#{bin}/bp_mutate -i test.fa -p 100 -n 1"))
    assert_match "GC content is 0.3750", shell_output("#{bin}/bp_gccalc test.fa")
  end
end
