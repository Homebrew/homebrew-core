class Cpm < Formula
  desc "Fast CPAN module installer"
  homepage "https://metacpan.org/pod/cpm"
  url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/App-cpm-0.998001.tar.gz"
  sha256 "f78f28a20e2792109a73228c83b53de5a7c6952af34476d72a2b7441d25a4508"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/skaji/cpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11a97390ecc4cc95f48059b592146b4128257f9567cd87f6d7f0999a6bc57375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a97390ecc4cc95f48059b592146b4128257f9567cd87f6d7f0999a6bc57375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a97390ecc4cc95f48059b592146b4128257f9567cd87f6d7f0999a6bc57375"
    sha256 cellar: :any_skip_relocation, sonoma:        "560d1b0fbeddda5c40dab45c55638fe2553d7c9943e489d709970a70e95c44d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3392b5750f986da3a2044c5a66d4d13e479fa4cae8d15344fb12f79754eca14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8837c14b738387f0909ccd460b32ce8ed3da51d2b0d7c39b7087032f94176a82"
  end

  depends_on "perl"

  conflicts_with "yaze-ag", because: "both install `cpm` binaries"

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.052.tar.gz"
    sha256 "bd10452c9f24d4b4fe594126e3ad231bab6cebf16acda40a4e8dc784907eb87f"
  end

  resource "CPAN::Common::Index" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/CPAN-Common-Index-0.010.tar.gz"
    sha256 "c43ddbb22fd42b06118fe6357f53700fbd77f531ba3c427faafbf303cbf4eaf0"
  end

  resource "CPAN::DistnameInfo" do
    url "https://cpan.metacpan.org/authors/id/G/GB/GBARR/CPAN-DistnameInfo-0.12.tar.gz"
    sha256 "2f24fbe9f7eeacbc269d35fc61618322fc17be499ee0cd9018f370934a9f2435"
  end

  resource "CPAN::Meta::Check" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/CPAN-Meta-Check-0.018.tar.gz"
    sha256 "f619d2df5ea0fd91c8cf83eb54acccb5e43d9e6ec1a3f727b3d0ac15d0cf378a"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
    sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
  end

  resource "Class::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Class-Tiny-1.008.tar.gz"
    sha256 "ee058a63912fa1fcb9a72498f56ca421a2056dc7f9f4b67837446d6421815615"
  end

  resource "Command::Runner" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Command-Runner-0.201.tar.gz"
    sha256 "38e3294ae9ffd015625d7746a0803cc329de92fb0f0edae9a29cd8232cf458d3"
  end

  resource "Darwin::InitObjC" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Darwin-InitObjC-0.001.tar.gz"
    sha256 "9a5f2887cb2fd427d64937743ffe3e748eab38b5b64906185fc243861e189f91"
  end

  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.010.tar.gz"
    sha256 "82e7e4e90cbe380e152f5de6e3e403746982d502dd30197a123652e46610c66d"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.028.tar.gz"
    sha256 "c8574875cce073e7dc5345a7b06d502e52044d68894f9160203fcaab379514fe"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.015.tar.gz"
    sha256 "7d64eb2dfa87ead010cdf55c8a1bdfde50b7b5852d7cb8cf2304f55bea2eb007"
  end

  resource "ExtUtils::MakeMaker::CPANfile" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/ExtUtils-MakeMaker-CPANfile-0.09.tar.gz"
    sha256 "2c077607d4b0a108569074dff76e8168659062ada3a6af78b30cca0d40f8e275"
  end

  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.45.tar.gz"
    sha256 "d3971cf78a8345e38042b208bb7b39cb695080386af629f4a04ffd6549df1157"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "File::pushd" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-pushd-1.016.tar.gz"
    sha256 "d73a7f09442983b098260df3df7a832a5f660773a313ca273fa8b56665f97cdc"
  end

  resource "HTTP::Tinyish" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/HTTP-Tinyish-0.19.tar.gz"
    sha256 "e9ce94a9913f9275d312ded4ddb34f76baf011b6b8d6029ff2871d5bd7bae468"
  end

  resource "IPC::Run3" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.049.tar.gz"
    sha256 "9d048ae7b9ae63871bae976ba01e081d887392d904e5d48b04e22d35ed22011a"
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

  resource "Module::cpmfile" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Module-cpmfile-0.006.tar.gz"
    sha256 "1bc976e2937724896c9f6eae9e5dca981e27f98430b92de270ee3514fd00ac0f"
  end

  resource "Parallel::Pipes" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Parallel-Pipes-0.201.tar.gz"
    sha256 "b73cbdd4202b29eab97e0c08dcd59d9273633610e8721cf449078656bd591a7c"
  end

  resource "Parse::LocalDistribution" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Parse-LocalDistribution-0.20.tar.gz"
    sha256 "664f4351e55ee9473c9b012af87d2832f652979cb89ade7954e6f38cd126a859"
  end

  resource "Parse::PMFile" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Parse-PMFile-0.47.tar.gz"
    sha256 "26817cf3d72e245452375dcff9e923a061ee0a40bbf060d3a08ebe60a334aaae"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Tie::Handle::Offset" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Tie-Handle-Offset-0.004.tar.gz"
    sha256 "ee9f39055dc695aa244a252f56ffd37f8be07209b337ad387824721206d2a89e"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
    sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
  end

  resource "Win32::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Win32-ShellQuote-0.003001.tar.gz"
    sha256 "aa74b0e3dc2d41cd63f62f853e521ffd76b8d823479a2619e22edb4049b4c0dc"
  end

  resource "YAML::PP" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-PP-v0.39.0.tar.gz"
    sha256 "32f53c65781277dcbe50827b4cbf217eceeff264779e3a6c98c94229eb149f58"
  end

  resource "local::lib" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/local-lib-2.000029.tar.gz"
    sha256 "8df87a10c14c8e909c5b47c5701e4b8187d519e5251e87c80709b02bb33efdd7"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_pl = [
      "Module::Build::Tiny",
      "Module::cpmfile",
      "Command::Runner",
      "Darwin::InitObjC",
      "Parallel::Pipes",
    ]

    resources.each do |r|
      r.stage do
        next if build_pl.include? r.name

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    build_pl.each do |name|
      resource(name).stage do
        system "perl", "Build.PL", "--install_base", libexec
        system "./Build"
        system "./Build", "install"
      end
    end

    system "perl", "Build.PL", "--install_base", libexec
    system "./Build"
    system "./Build", "install"

    (bin/"cpm").write_env_script("#{libexec}/bin/cpm", PERL5LIB: ENV["PERL5LIB"])
    man1.install_symlink libexec/"man/man1/cpm.1"
    man3.install_symlink Dir[libexec/"man/man3/App::cpm*"].reject { |f| File.empty?(f) }
  end

  test do
    system bin/"cpm", "install", "Perl::Tutorial"

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
                 shell_output("PERL5LIB=local/lib/perl5 perldoc Perl::Tutorial::HelloWorld")
  end
end
