class Libbi < Formula
  desc "Bayesian state-space modelling on parallel computer hardware"
  homepage "https://libbi.org/"
  url "https://github.com/lawmurray/LibBi/archive/refs/tags/1.4.5.tar.gz"
  sha256 "af2b6d30e1502f99a3950d63ceaf7d7275a236f4d81eff337121c24fbb802fbe"
  license "GPL-2.0-only"
  revision 5
  head "https://github.com/lawmurray/LibBi.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f74c4b74ae27fdb5d3f3e1c37ab120cf0c12f6830a8477f331fc2d312335a29f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fef4f3574955d3f11d14e49034c502988764eb169d5b4a74fc8dbbfce461225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6cacb6474adcb43e3e4cc0434721b474a8a9749102c397fd0e69fe3ff4e8333"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf5a58e1570912775cc3899a89e5567ac5f657956833947bb2888c4949b4169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0882b756fb10921769635c9c858998d5cf85630a954af71eb7e2380c888937a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5dcac53e5859b062603ed726c70d2d4fb9d46e317a9238ec5e4ff3c973f41cc"
    sha256 cellar: :any_skip_relocation, ventura:        "ef73bed34be4fd7cb1579190d6422266e84aca5bb7da499720bce3ff3f56f7c9"
    sha256 cellar: :any_skip_relocation, monterey:       "70f2987d8bc35f8d6dc5004e02c46e4d8936e30dd2472821f2247126b56bba10"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9d7b9882a40417f97c719dee775dd0fdf9c54d25c0717a96101105f4cd82540a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f25556a4e78e00b4cfd286563a225f5ccb4c200510461dbd21925b662f6e89"
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
    url "https://github.com/NVIDIA/thrust/archive/refs/tags/1.8.2.tar.gz"
    sha256 "83bc9e7b769daa04324c986eeaf48fcb53c2dda26bcc77cb3c07f4b1c359feb8"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        next if r.name == "thrust"

        # need to set TT_ACCEPT=y for Template library for non-interactive install
        perl_flags = (r.name == "Template") ? "TT_ACCEPT=y" : ""
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", perl_flags
        system "make"
        system "make", "install"
      end
    end

    resource("thrust").stage { (include/"thrust").install Dir["thrust/*"] }

    # make Homebrew packages discoverable for compilation/linking
    inreplace "share/configure.ac" do |s|
      cppflags = s.get_make_var("CPPFLAGS").delete('"')
      ldflags = s.get_make_var("LDFLAGS").delete('"')
      s.change_make_var! "CPPFLAGS", "\"#{cppflags} -I#{HOMEBREW_PREFIX}/include\""
      s.change_make_var! "LDFLAGS", "\"#{ldflags} -L#{HOMEBREW_PREFIX}/lib\""
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLSITESCRIPT=#{bin}"
    system "make"
    system "make", "install"

    pkgshare.install "Test.bi", "test.conf"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib" if OS.linux?
    cp Dir[pkgshare/"Test.bi", pkgshare/"test.conf"], testpath
    system bin/"libbi", "sample", "@test.conf"
    assert_path_exists testpath/"test.nc"
  end
end
