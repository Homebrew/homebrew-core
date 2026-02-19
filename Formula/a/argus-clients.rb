class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://openargus.org"
  url "https://github.com/openargus/clients/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "c695e69f8cfffcb6ed978f1f29b1292a2638e4882a66ea8652052ba1e42fe8bc"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae80fb8ebf1ce278fb8c74c1a7a9f4fdb5e615103e15dc63283c217ebf525024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6da67dbd52f3e1bb62e7f8a04a18c0b07f73bcd3fb4cd3415d62dc58b973846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88978797864547020e800351c13576b07d7c4e6b4ac96285c0dd551c136d4790"
    sha256 cellar: :any_skip_relocation, sonoma:        "06fe4d80aadbd2a0d4cec2963d92706f7d168c9d43fff983689ac6aa755e9e70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51a9b33724d646314c65efc2841ada96f7825dfa8384aa9d6ecf0a8fbaaf4cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda872f8bd03edefe8f6c54e096030be6f21e7515c37dfc507944a56944d82db"
  end

  depends_on "perl"
  depends_on "readline"
  depends_on "rrdtool"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libtirpc"
    depends_on "zlib-ng-compat"
  end

  resource "Switch" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    sha256 "31354975140fe6235ac130a109496491ad33dd42f9c62189e23f49f75f936d75"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc" if OS.linux?

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV["PERL_EXT_LIB"] = libexec/"lib/perl5"

    system "./configure", "--prefix=#{prefix}", "--without-examples"
    system "make"
    system "make", "install"
  end

  test do
    ENV["PERL5LIB"] = libexec/"lib/perl5"
    system "perl", "-e", "use qosient::util;"

    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
