class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.68.tar.gz"
  sha256 "5eb14bc7bc1407743478ebdbd83772bf3b927fd949136a2fbbde96fa6000b6e7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7906d5c61df0f103ce58bc56c3ea187e4fedb7c3dd8e2cadea39f474dbf4972b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68552a226793171ccdf363e124310009b4326f73261883f9960b7baa1e76a288"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e06a52a51ba1becf71fcf028fae19cba7c16b1fb7996f9f8b95aa4c6d77b66ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce98324a0faa7ece95d8375d34e9c3ad0feaedc50f3a1e28eafcb3de5d64aab1"
    sha256 cellar: :any_skip_relocation, ventura:        "ac599b305b01691344ecc270d481d2db2755d372708defe3883a3fe98865efb1"
    sha256 cellar: :any_skip_relocation, monterey:       "82bad00c3dc665b51aa413ed881c017eef667ed11886b912174a157f2b1c8a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6a9cf5f24e92ed5cd78ce4bce60192733c8e10965ecc53747a66539b7e2f21"
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
