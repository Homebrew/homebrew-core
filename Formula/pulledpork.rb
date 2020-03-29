class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/v0.7.3.tar.gz"
  sha256 "48c66dc9abb7545186d4fba497263c1d1b247c0ea7f0953db4d515e7898461a2"
  revision 3
  head "https://github.com/shirkdog/pulledpork.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b7202182f284a0f71563981e9a0fe833338f85141d1b798996bc5fa91c070b2" => :catalina
    sha256 "a58bf34832bfb17003541e1bc081314be348dc2710742143297d7feaab304a64" => :mojave
    sha256 "9374159d0d80d83e20c4afb1dbb293d038dac84292ab73fb51155e4cf8c825f5" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "perl"

  resource "Switch" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    sha256 "31354975140fe6235ac130a109496491ad33dd42f9c62189e23f49f75f936d75"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    inreplace "pulledpork.pl", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    chmod 0755, "pulledpork.pl"
    bin.install "pulledpork.pl"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    doc.install Dir["doc/*"]
    (etc/"pulledpork").install Dir["etc/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulledpork.pl -V")
  end
end
