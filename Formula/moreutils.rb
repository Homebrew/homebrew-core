class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/git/moreutils.git",
      tag:      "0.66",
      revision: "f0642d6331e89ca5a6ced8c0f1744428983e1780"
  license all_of: [
    "GPL-2.0-or-later",
    { any_of: ["GPL-2.0-only", "Artistic-2.0"] },
  ]
  head "https://git.joeyh.name/git/moreutils.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93055c0a353c93a20b0421a85eb055cc54340d1793cf12dd0fad275be123b71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7bb6a5498e898c303cbbb526f83a12e690315c43260ebab1cf348ecb2a712bb"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5c2460a0d242df46376e618207038722ffc65a9e3e6379fdd229ce821f4d52"
    sha256 cellar: :any_skip_relocation, big_sur:        "98e36f509fe2556660dec088c1dcf380cf1ce60167fcb4289782614feb381821"
    sha256 cellar: :any_skip_relocation, catalina:       "e7774183139434a9f4707a5931793fb2aed0678fd0257a5860571f320f507c8e"
    sha256 cellar: :any_skip_relocation, mojave:         "099c5b0cc96ae204c211da65446db79bf83469ed0bcbc40d81e5a9e95b5a678c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0890cc88f2e311ec01cc0439cbfa6a7a43166ebaeb54a8bfa9d22fc21fba4bb4"
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
