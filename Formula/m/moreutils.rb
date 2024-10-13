class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.69.tar.gz"
  sha256 "0f795d25356ca61544966646fb707d5be0b9864116be0269df5433f62d4e05d1"
  license all_of: [
    "GPL-2.0-or-later",
    { any_of: ["GPL-2.0-only", "Artistic-2.0"] },
  ]
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "893d69604e34e0307ae8f329d6661dfd949ef46ed8daba2c702b80f83a071c9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d670db1141e2452a4384a659743e919965b1f4bb15df8bf249a4e2de219a1fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37630eb130415e996c7cf3c4333d788d3a6cb7eead141b06dc2b8ab48812c674"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "572eac728e9dfb5791dc1d7e5ec4c54d7afad32320ab71dff2c32038e41487ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "081eb804ba4b73fe2025b5da85b0d84692a5e1f185e13f57ffa672a013069dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "bd9bd5a1c203fe83a9bbf171b8db8fa2326f2c31e6ca0ec862346981db7420fa"
    sha256 cellar: :any_skip_relocation, monterey:       "154af5f7e744eeda14286f122af89b6444cf00300fabbd4a3ee4f4c80523b07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e309aded89d7c99d8310fab2123e256f2d37de5e2b574a859cda5c06082f867e"
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
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-20231003.0.tar.gz"
    sha256 "eb25bbdf5913d291797ef1bfe998f15130b455d3ed02aacde6856f0b25e4fe57"
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
