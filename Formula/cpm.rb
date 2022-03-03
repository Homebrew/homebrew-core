class Cpm < Formula
  desc "Fast CPAN module installer"
  homepage "https://metacpan.org/pod/cpm"
  url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/App-cpm-0.997008.tar.gz"
  sha256 "5f20eecc30ad80282dcc850c1c63b42f1d9b176ee72b0c4e412eff7ad886aea5"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/skaji/cpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7a6e105bda3a926698a02d3c6033dff0c967b748147f08c20938ff7aee8896"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a7a6e105bda3a926698a02d3c6033dff0c967b748147f08c20938ff7aee8896"
    sha256 cellar: :any_skip_relocation, monterey:       "1ca20eac6d6a73d837551409cbf72a1c4750c3d690c5e7d178e61d0ffc3647a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ca20eac6d6a73d837551409cbf72a1c4750c3d690c5e7d178e61d0ffc3647a6"
    sha256 cellar: :any_skip_relocation, catalina:       "1ca20eac6d6a73d837551409cbf72a1c4750c3d690c5e7d178e61d0ffc3647a6"
    sha256 cellar: :any_skip_relocation, mojave:         "1ca20eac6d6a73d837551409cbf72a1c4750c3d690c5e7d178e61d0ffc3647a6"
  end

  depends_on "perl"

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    sha256 "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c"
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

  resource "Command::Runner" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Command-Runner-0.103.tar.gz"
    sha256 "0f180b5c3b3fc9db7b83d4a5fdd959db34f7d6d2472f817dbf8b4b795a9dc82a"
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

  resource "Module::cpmfile" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Module-cpmfile-0.006.tar.gz"
    sha256 "1bc976e2937724896c9f6eae9e5dca981e27f98430b92de270ee3514fd00ac0f"
  end

  resource "Parallel::Pipes" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Parallel-Pipes-0.101.tar.gz"
    sha256 "a5a08a6b3a4b0a3e17ea64fb7c174570522558125ed0e2f507eb189f2855c9f4"
  end

  resource "Parse::PMFile" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Parse-PMFile-0.43.tar.gz"
    sha256 "be61e807204738cf0c52ed321551992fdc7fa8faa43ed43ff489d0c269900623"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.10.tar.gz"
    sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
  end

  resource "Win32::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Win32-ShellQuote-0.003001.tar.gz"
    sha256 "aa74b0e3dc2d41cd63f62f853e521ffd76b8d823479a2619e22edb4049b4c0dc"
  end

  resource "YAML::PP" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-PP-0.031.tar.gz"
    sha256 "d7c837f732b023b67aa3666d14887f1cd756ce5c5bb6b07eee0b3701cf9e4cf8"
  end

  resource "local::lib" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/local-lib-2.000028.tar.gz"
    sha256 "408317d67a59f9f91e23e3000b82de4f529cf9cf0896e228f3a27d6f607bfe3d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_pl = [
      "Module::Build::Tiny",
      "Module::cpmfile",
      "Command::Runner",
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
