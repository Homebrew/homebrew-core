class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/v0.7.4.tar.gz"
  sha256 "f0149eb6f723b622024295e0ee00e1acade93fae464b9fdc323fdf15e99c388c"
  license "GPL-2.0-or-later"
  head "https://github.com/shirkdog/pulledpork.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c426bbb74ebe2d71cdcc359b5b627d3cee771138be816e22aafcf9bacab773e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c426bbb74ebe2d71cdcc359b5b627d3cee771138be816e22aafcf9bacab773e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d356a368ba34f3ebabf869b9edf2038d962b7cdd661be3317e3b3b68b825c03"
    sha256 cellar: :any_skip_relocation, ventura:        "9ac992cb245188689c716615660393ff8904ed48b56ddf5d5b36df147274480c"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac992cb245188689c716615660393ff8904ed48b56ddf5d5b36df147274480c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef9c66506c6ac34967fbc3c9bf48ecfc2946814a2dccb3e1fb53f1212e7a3bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "deaaf558752aa6c864008dbf4cd058850d4206f5e97b50bc6e1f5b2706694fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f925daf30d6bdfa68a3d8ebf2e2d0fef9a069aa14cd6d45c2b1e41b72665acdd"
  end

  depends_on "openssl@3"

  uses_from_macos "perl"

  on_linux do
    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "HTTP::Request" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.36.tar.gz"
      sha256 "576a53b486af87db56261a36099776370c06f0087d179fc8c7bb803b48cddd76"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.10.tar.gz"
      sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end

    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.64.tar.gz"
      sha256 "48335e0992b4875bd73c6661439f3506c2c6d92b5dd601582b8dc22e767d3dae"
    end
  end

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
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    doc.install Dir["doc/*"]
    (etc/"pulledpork").install Dir["etc/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulledpork.pl -V")
  end
end
