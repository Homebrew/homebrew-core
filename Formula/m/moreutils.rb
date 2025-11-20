class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.70.tar.gz"
  sha256 "f2bf46d410ba567cc8d01507e94916994e48742722e690dc498fab59f5250132"
  license all_of: [
    "GPL-2.0-or-later",
    { any_of: ["GPL-2.0-only", "Artistic-2.0"] },
  ]
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb9c8584114eafbe7eab4f89b0502d72688b7ea7d1dea6fd485a1bd5e5541149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d054e5d66851413c272c39e156a48467f39959e89c84f91c1de41cd690c6b78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0990b48df79c064ba76b72360019bea03328e6fcbd99a866ab9d6a1a37e95f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52bc03dcf5828555287e4f2ddd22da821a332a07f73118449dfd7fb9b86bf2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e26e5d2933b3012c95929c26c6d7298a1820370f9b15e2c05fa10ca4e8b020f5"
    sha256 cellar: :any_skip_relocation, ventura:       "42dc76da4d89f2bea57718ad8ccba438651099ee27881b5a8e34c9052777947f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f3ea30db435d1e85633c12f11dc1d4545530c21f0415999b651be6b7d02306f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d1c740d7401fec23a230bcd5f113e8d10c00c0d80f8b12861acc5d64b79b3a"
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
