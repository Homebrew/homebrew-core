class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/v0.7.3.tar.gz"
  sha256 "48c66dc9abb7545186d4fba497263c1d1b247c0ea7f0953db4d515e7898461a2"
  revision 2
  head "https://github.com/shirkdog/pulledpork.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "addf133e8e7c55f1ef9ecfe045693b90f94bdea684eecd670880faff709e2ab1" => :catalina
    sha256 "090fa5e477bbb0ff2335db1c18416c9dc42108ff9c7c3b402f67f44dd8a4bd2b" => :mojave
    sha256 "fd5427bcedfb95ccc79eb984e96b044727ae82bea91ef9c255a0cdb197d867fd" => :high_sierra
    sha256 "51e5d134f6e9e6ac2085ffb014257b18edce15e2570553ef0ec9167a59d90169" => :sierra
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
