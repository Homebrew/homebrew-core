class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 7
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d48c0bb6461e832eb2f015fe1193cc1c588536c58725af9c1b07a86783796097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a11995e26b9cc7ff6463cf06490ccff51ff0f861761d6e04a76fbd7de6d3b4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f590defa9a11f31f5a3493b0ba55bd3a045ee1250cc21e245c19e7c200ba1a"
    sha256 cellar: :any_skip_relocation, tahoe:         "df857d43cd4f2bcb1c3742f06f5f94afd56844c10ceb6cc73516264abb2c5713"
    sha256 cellar: :any_skip_relocation, sequoia:       "5f237514d17707ff644d4468fdd40a4038483934e2ccd134e89728a8636a385c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4ed8fbf99a47db5a89672ea99f5c67c1bc7ceac9b89fb0994423fb38c0310e"
    sha256 cellar: :any,                 arm64_linux:   "7f5d3944ddd0f37896a33b585a79e30b29ad81dcb4f4b59a9847af4d796e6bce"
    sha256 cellar: :any,                 x86_64_linux:  "58cbd6cdf4f6a8ff4b41ed078e4d58818757268a3fcfca45d2722d54e173387c"
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

    depends_on "berkeley-db@5"
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
