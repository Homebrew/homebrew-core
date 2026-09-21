class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20260826/Perl-Tidy-20260826.tar.gz"
  sha256 "104e3e5ee5c84524d5e50324d664c7859b1ac422ab97a3e7a248985a4b4f7f64"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ea81ffa8a0bdc1cf59c5164e9e403bc43a05b2aef8b84c4224052f50af2dd45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ea81ffa8a0bdc1cf59c5164e9e403bc43a05b2aef8b84c4224052f50af2dd45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ea81ffa8a0bdc1cf59c5164e9e403bc43a05b2aef8b84c4224052f50af2dd45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6ea81ffa8a0bdc1cf59c5164e9e403bc43a05b2aef8b84c4224052f50af2dd45"
    sha256 cellar: :any_skip_relocation, sonoma:            "b7499848e07ec98c29eaf2a034a2640e6d206b38f1a5899cae13a0cc23d0d4fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1bdc238e368a4029736a77c69d72d1c59ac4d1a33ee4c170a1dbbde58f9b5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bf5e7362a9ea3ea23e431f32732aa8d01f0fbdd0db89a55b9830f97ac076a6f5"
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"testfile.pl").write <<~PERL
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?";
      } else {
        print "I think that's the problem";
      }
    PERL
    system bin/"perltidy", testpath/"testfile.pl"
    assert_equal <<~PERL, (testpath/"testfile.pl.tdy").read
      print "Help Desk -- What Editor do you use?";
      chomp( $editor = <STDIN> );
      if ( $editor =~ /emacs/i ) {
          print "Why aren't you using vi?";
      }
      elsif ( $editor =~ /vi/i ) {
          print "Why aren't you using emacs?";
      }
      else {
          print "I think that's the problem";
      }
    PERL
  end
end
