class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/v0.7.4.tar.gz"
  sha256 "f0149eb6f723b622024295e0ee00e1acade93fae464b9fdc323fdf15e99c388c"
  license "GPL-2.0-or-later"
  head "https://github.com/shirkdog/pulledpork.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "035ca3f72d7950b0446825984e779be22a25b2b8b180f226eb7589120092673e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fef43eada21d5f8e2adb9f4d69a4baf81626734cf732c4c2f630b176a70b58b"
    sha256 cellar: :any_skip_relocation, catalina:      "f1e692043de24e99030c5e07a4c11269e091af1748f2bf910048f016358581b6"
    sha256 cellar: :any_skip_relocation, mojave:        "8f4884077fee641db519a021f0b47c739165546b8dd8b07a4ea4d1a2f8918aaf"
    sha256 cellar: :any_skip_relocation, high_sierra:   "00f4875c0b5e47644250f39845f90f9a78f10152f489d5c103046f48cd0d5f0a"
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
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    doc.install Dir["doc/*"]
    (etc/"pulledpork").install Dir["etc/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulledpork.pl -V")
  end
end
