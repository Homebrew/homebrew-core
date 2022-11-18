class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/git/moreutils.git",
      tag:      "0.67",
      revision: "ee8e013cd5398c5fb34fb19a24db0f3b6185bac3"
  license all_of: [
    "GPL-2.0-or-later",
    { any_of: ["GPL-2.0-only", "Artistic-2.0"] },
  ]
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2d7aea31dd1470da60cf4c7382407338c8bbc9806765a8eeb22084fb86541df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97487d8fcda41988e9b03a87770260953fc05e2282e069a35fc5742e804ed0ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8ddb7455bee7e0dfc6b870a36c4cc2eb6462058d69f19d104c9522386a49ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "3b2c236961b8496b18456e54fa3561ca227532c6f855f2f95d86bc69dc2c30a4"
    sha256 cellar: :any_skip_relocation, monterey:       "4bbca70595aa3ebf16c1297b00725a95d32220e5b849db8b024b724a953e923a"
    sha256 cellar: :any_skip_relocation, big_sur:        "89bba0318b0d38d10e799a4d8a39b2b1e32bcab22cb416f73aff938c765b8d3e"
    sha256 cellar: :any_skip_relocation, catalina:       "6436bbcfa0d40fe6977f76e212665c89120a920c1e6b2661ea8fbb675ab2e4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "585a1be3b05cb1a625571aaa5ecf67333cbd2c329152e0526b6dee4510015a76"
  end

  depends_on "docbook-xsl" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build

  uses_from_macos "perl"

  conflicts_with "parallel", because: "both install a `parallel` executable"
  conflicts_with "pwntools", because: "both install an `errno` executable"
  conflicts_with "sponge", because: "both install a `sponge` executable"
  conflicts_with "task-spooler", because: "both install a `ts` executable"

  resource "Time::Duration" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Time-Duration-1.21.tar.gz"
    sha256 "fe340eba8765f9263694674e5dff14833443e19865e5ff427bbd79b7b5f8a9b8"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-20200505.0.tar.gz"
    sha256 "816ebf217fa0df99c583d73c0acc6ced78ac773787c664c75cbf140bb7e4c901"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Time::Duration").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "--skipdeps"
      system "make", "install"
    end

    resource("IPC::Run").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    inreplace "Makefile" do |s|
      s.gsub! "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    pipe_output("#{bin}/isutf8", "hello", 0)
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7", 1)
  end
end
