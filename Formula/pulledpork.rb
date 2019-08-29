class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/v0.7.3.tar.gz"
  sha256 "48c66dc9abb7545186d4fba497263c1d1b247c0ea7f0953db4d515e7898461a2"
  revision 2
  head "https://github.com/shirkdog/pulledpork.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "729c107b7df7b94421cf1b0b928aa5645df19709e20466e82a8b08787d59d62e" => :mojave
    sha256 "aada89892608c0411260a165a404f372983873187703643bb9e57239b907cbd3" => :high_sierra
    sha256 "ba233cd6ace4db24faf5dd0b36523ef4d53ac1c92ba2f5ef54040883f07daf5f" => :sierra
  end

  depends_on "openssl@1.1"

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
