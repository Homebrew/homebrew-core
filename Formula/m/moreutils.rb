class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://deb.debian.org/debian/pool/main/m/moreutils/moreutils_0.70.orig.tar.xz"
  sha256 "a844c5e3360a73d12c0a5624750ecc1969d64afea2e84925328f137576e2eb55"
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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a7ff4ef8702f3fe3e31a148f87b1a5051804d9b971069fda621668cfd9b397d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4791896aa6bbf8d7cc1a59c11210c687960fb2e6a30980bcf39fe5963de44434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a381a17a5d3a4db5e311c622d78cf23dbe823b3ffe14fe33eba0269c3eb274bf"
    sha256 cellar: :any,                 arm64_linux:       "a62fe5d94e08dedbb81b2fb11dfd1f2d6af480405da084232dada7f18123e363"
    sha256 cellar: :any,                 x86_64_linux:      "9e091816d85d311cbee7a188d3ce74a8705d163af9bb80e76981352599002ef8"
  end

  depends_on "docbook-xsl" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build

  uses_from_macos "perl"

  conflicts_with "parallel", because: "both install a `parallel` executable"
  conflicts_with "pwntools", because: "both install an `errno` executable"
  conflicts_with "sponge", because: "both install a `sponge` executable"
  conflicts_with "task-spooler", because: "both install a `ts` executable"

  resource "Date::Parse" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.35.tar.gz"
      sha256 "baddd0306ae2e86e9ec28d3de5439e514643e80b3735e43bd0fbb426d73304de"
    end
  end

  resource "Time::Duration" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Time-Duration-1.21.tar.gz"
    sha256 "fe340eba8765f9263694674e5dff14833443e19865e5ff427bbd79b7b5f8a9b8"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-20260402.0.tar.gz"
    sha256 "d6a326a8b1ffb19495dea4ff5a09ef138bf3562ab1b069d3fb7efbc77b9f6aca"
  end

  deny_network_access!

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                      "INSTALLMAN3DIR=none",
                                      "NO_PACKLIST=1",
                                      "NO_PERLLOCAL=1"
        system "make", "install"
      end
    end

    inreplace "Makefile" do |s|
      s.gsub! "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              "#{formula_opt_prefix("docbook-xsl")}/docbook-xsl"
    end
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    pipe_output("#{bin}/isutf8", "hello", 0)
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7", 1)
  end
end
