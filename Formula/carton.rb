class Carton < Formula
  desc "Perl module dependency manager (aka Bundler for Perl)"
  homepage "https://metacpan.org/pod/Carton"
  url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Carton-v1.0.34.tar.gz"
  sha256 "77d42b92732bcfc18a59d341e56ce476205b1c4d380eab3a07224f5745c23e45"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 2
  head "https://github.com/perl-carton/carton.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69bbc1bd1bc735b403d4e229cc927e797e890fd062b4cef1aa02844ddfda3d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ce1ddd8777839a7c6335edb8aeccb0603e7199f77e8535039888e4f17c1c16b"
    sha256 cellar: :any_skip_relocation, monterey:       "9fcc9df862efb089bd695be67739a32851bb7912284abe70806c46422dcdc9fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8346120d0c0c90969deffae1f9f6a62cd801b85d960236a027ac01a66bb8764"
    sha256 cellar: :any_skip_relocation, catalina:       "089c962c1d804848a5b1c00d424b840f4f97d56c9bc36628b660af9cf4d2ab13"
    sha256 cellar: :any_skip_relocation, mojave:         "151b0beef68a8538b731e39e8bea4325279b2912f491c2be5f0a8ab8fde68123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80f86c001f8fb0a49b809d66d3223db970ed12cba4e20e6af7c073e85842a34f"
  end

  depends_on "perl"

  resource "CPAN::Common::Index" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/CPAN-Common-Index-0.010.tar.gz"
    sha256 "c43ddbb22fd42b06118fe6357f53700fbd77f531ba3c427faafbf303cbf4eaf0"
  end

  resource "CPAN::DistnameInfo" do
    url "https://cpan.metacpan.org/authors/id/G/GB/GBARR/CPAN-DistnameInfo-0.12.tar.gz"
    sha256 "2f24fbe9f7eeacbc269d35fc61618322fc17be499ee0cd9018f370934a9f2435"
  end

  resource "CPAN::Meta::Check" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/CPAN-Meta-Check-0.014.tar.gz"
    sha256 "28a0572bfc1c0678d9ce7da48cf521097ada230f96eb3d063fcbae1cfe6a351f"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end

  resource "Class::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Class-Tiny-1.008.tar.gz"
    sha256 "ee058a63912fa1fcb9a72498f56ca421a2056dc7f9f4b67837446d6421815615"
  end

  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz"
    sha256 "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz"
    sha256 "de901b6790a4557cf4ec908149e035783b125bf115eb9640feb1bc1c24c33416"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.012.tar.gz"
    sha256 "84735e3037bab1fdffa3c2508567ad412a785c91599db3c12593a50a1dd434ed"
  end

  resource "ExtUtils::MakeMaker::CPANfile" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/ExtUtils-MakeMaker-CPANfile-0.09.tar.gz"
    sha256 "2c077607d4b0a108569074dff76e8168659062ada3a6af78b30cca0d40f8e275"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz"
    sha256 "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078"
  end

  resource "File::pushd" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-pushd-1.016.tar.gz"
    sha256 "d73a7f09442983b098260df3df7a832a5f660773a313ca273fa8b56665f97cdc"
  end

  resource "HTTP::Tinyish" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/HTTP-Tinyish-0.17.tar.gz"
    sha256 "47bd111e474566d733c41870e2374c81689db5e0b5a43adc48adb665d89fb067"
  end

  resource "IPC::Run3" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz"
    sha256 "3d81c3cc1b5cff69cca9361e2c6e38df0352251ae7b41e2ff3febc850e463565"
  end

  resource "Menlo" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Menlo-1.9019.tar.gz"
    sha256 "3b573f68e7b3a36a87c860be258599330fac248b518854dfb5657ac483dca565"
  end

  resource "Menlo::Legacy" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Menlo-Legacy-1.9022.tar.gz"
    sha256 "a6acac3fee318a804b439de54acbc7c27f0b44cfdad8551bbc9cd45986abc201"
  end

  resource "Module::CPANfile" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Module-CPANfile-1.1004.tar.gz"
    sha256 "88efbe2e9a642dceaa186430fedfcf999aaf0e06f6cced28a714b8e56b514921"
  end

  resource "Parse::PMFile" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Parse-PMFile-0.43.tar.gz"
    sha256 "be61e807204738cf0c52ed321551992fdc7fa8faa43ed43ff489d0c269900623"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.114.tar.gz"
    sha256 "cd0f88f37a58fc3667ec065767fe01e73ee6efa18a112bfd3508cf6579ca00e1"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Tie::Handle::Offset" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Tie-Handle-Offset-0.004.tar.gz"
    sha256 "ee9f39055dc695aa244a252f56ffd37f8be07209b337ad387824721206d2a89e"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
    sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.05.tar.gz"
    sha256 "a5c113d2d02706d9fbdca6a86f290c5b05b2f86836d4e7fe1447f063261b79ec"
  end

  resource "Win32::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Win32-ShellQuote-0.003001.tar.gz"
    sha256 "aa74b0e3dc2d41cd63f62f853e521ffd76b8d823479a2619e22edb4049b4c0dc"
  end

  resource "local::lib" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/local-lib-2.000024.tar.gz"
    sha256 "2e9b917bd48a0615e42633b2a327494e04610d8f710765b9493d306cead98a05"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"

    (bin/"carton").write_env_script("#{libexec}/bin/carton", PERL5LIB: ENV["PERL5LIB"])
    man1.install_symlink libexec/"man/man1/carton.1"
    man3.install_symlink Dir[libexec/"man/man3/Carton*"]
  end

  test do
    (testpath/"cpanfile").write <<~EOS
      requires 'Perl::Tutorial';
    EOS
    system bin/"carton", "install"

    expected = <<~EOS
      NAME
          Perl::Tutorial::HelloWorld - Hello World for Perl

      SYNOPSIS
            #!/usr/bin/perl
            #
            # The traditional first program.

            # Strict and warnings are recommended.
            use strict;
            use warnings;

            # Print a message.
            print "Hello, World!\\n";
    EOS
    assert_match expected,
                 shell_output("#{bin}/carton exec perldoc Perl::Tutorial::HelloWorld")
  end
end
