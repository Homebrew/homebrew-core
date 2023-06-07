class Libbi < Formula
  desc "Bayesian state-space modelling on parallel computer hardware"
  homepage "https://libbi.org/"
  url "https://github.com/lawmurray/LibBi/archive/1.4.5.tar.gz"
  sha256 "af2b6d30e1502f99a3950d63ceaf7d7275a236f4d81eff337121c24fbb802fbe"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/lawmurray/LibBi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44bf6f88c1eba7e0d73d9865c2bc3d01750183c4a4c28e8376947adf1576ddcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae593b0f46cfb4176070508a9ecf1379ab1ce5c6d6946f067455854751545ee9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95b9bd0f690a89f42ec6a1e670248a5464ba14fc7e80589a6bc4b28788a30f1d"
    sha256 cellar: :any_skip_relocation, ventura:        "dd70fd096c61c3df6ac7ae162bdca03aca0b4208350e39b050bfb2e3cef8ae9d"
    sha256 cellar: :any_skip_relocation, monterey:       "25e4409e1cc95c4759c2b0c338db8fdc30245c5ec6d6f068d77ed148a224a80d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9739fadb79161f0b2db4e73d8ff9bbe2c2bc3f9c40bebc6fb6cadc9387121741"
    sha256 cellar: :any_skip_relocation, catalina:       "fa9a991443966cd592070a228cf2d8092b3e154eda52ac390ea756d03b30e670"
    sha256 cellar: :any_skip_relocation, mojave:         "c90c7105c8eaa9bb53ce0fc9e608dc0c4df8d082361846ce764dfc0d141ec5b4"
  end

  depends_on "automake"
  depends_on "boost"
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "qrupdate"

  uses_from_macos "perl"

  resource "Test::Simple" do
    url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302133.tar.gz"
    sha256 "02bc2b4ec299886efcc29148308c9afb64e0f2c2acdeaa2dee33c3adfe6f96e2"
  end

  resource "Getopt::ArgvFile" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTENZEL/Getopt-ArgvFile-1.11.tar.gz"
    sha256 "3709aa513ce6fd71d1a55a02e34d2f090017d5350a9bd447005653c9b0835b22"
  end

  resource "Carp::Assert" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Carp-Assert-0.21.tar.gz"
    sha256 "924f8e2b4e3cb3d8b26246b5f9c07cdaa4b8800cef345fa0811d72930d73a54e"
  end

  resource "File::Slurp" do
    url "https://cpan.metacpan.org/authors/id/U/UR/URI/File-Slurp-9999.19.tar.gz"
    sha256 "ce29ebe995097ebd6e9bc03284714cdfa0c46dc94f6b14a56980747ea3253643"
  end

  resource "Parse::Yapp" do
    url "https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
    sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
  end

  resource "Parse::Template" do
    url "https://cpan.metacpan.org/authors/id/P/PS/PSCUST/ParseTemplate-3.08.tar.gz"
    sha256 "3c7734f53999de8351a77cb09631d7a4a0482b6f54bca63d69d5a4eec8686d51"
  end

  resource "Parse::Lex" do
    url "https://cpan.metacpan.org/authors/id/P/PS/PSCUST/ParseLex-2.21.tar.gz"
    sha256 "f55f0a7d1e2a6b806a47840c81c16d505c5c76765cb156e5f5fd703159a4492d"
  end

  resource "Parse::RecDescent" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
    sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
  end

  resource "Math::Symbolic" do
    url "https://cpan.metacpan.org/authors/id/S/SM/SMUELLER/Math-Symbolic-0.612.tar.gz"
    sha256 "a9af979956c4c28683c535b5e5da3cde198c0cac2a11b3c9a129da218b3b9c08"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
    sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
  end

  resource "File::Remove" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.57.tar.gz"
    sha256 "b3becd60165c38786d18285f770b8b06ebffe91797d8c00cc4730614382501ad"
  end

  resource "inc::Module::Install::DSL" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.19.tar.gz"
    sha256 "1a53a78ddf3ab9e3c03fc5e354b436319a944cba4281baf0b904fa932a13011b"
  end

  resource "Class::Inspector" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.32.tar.gz"
    sha256 "cefadc8b5338e43e570bc43f583e7c98d535c17b196bcf9084bb41d561cc0535"
  end

  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.104.tar.gz"
    sha256 "07b628efcdf902d6a32e6a8e084497e8593d125c03ad12ef5cc03c87c7841caf"
  end

  resource "Template" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABW/Template-Toolkit-2.27.tar.gz"
    sha256 "1311a403264d0134c585af0309ff2a9d5074b8ece23ece5660d31ec96bf2c6dc"
  end

  resource "Graph" do
    url "https://cpan.metacpan.org/authors/id/J/JH/JHI/Graph-0.9704.tar.gz"
    sha256 "325e8eb07be2d09a909e450c13d3a42dcb2a2e96cc3ac780fe4572a0d80b2a25"
  end

  resource "thrust" do
    url "https://github.com/NVIDIA/thrust/archive/1.8.2.tar.gz"
    sha256 "83bc9e7b769daa04324c986eeaf48fcb53c2dda26bcc77cb3c07f4b1c359feb8"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        next if r.name == "thrust"

        # need to set TT_ACCEPT=y for Template library for non-interactive install
        perl_flags = "TT_ACCEPT=y" if r.name == "Template"
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", perl_flags
        system "make"
        system "make", "install"
      end
    end

    resource("thrust").stage { (include/"thrust").install Dir["thrust/*"] }

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLSITESCRIPT=#{bin}"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # See, e.g., https://github.com/Homebrew/homebrew-core/issues/4936
    inreplace "script/libbi", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    system "make"
    system "make", "install"

    pkgshare.install "Test.bi", "test.conf"
    bin.env_script_all_files(libexec+"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    cp Dir[pkgshare/"Test.bi", pkgshare/"test.conf"], testpath
    system "#{bin}/libbi", "sample", "@test.conf"
    assert_predicate testpath/"test.nc", :exist?
  end
end
