class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/refs/tags/v1.64.tar.gz"
  sha256 "30c3952600b694a98a0e0ee20ecbbc02d0c70ca96194e3719e9177409af6c5c9"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]
  revision 1

  # Ignore `debian/<version>` tags
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aa93cbbde9e9eb7cf1e7055b9f05c5505651d7d12144562edd7df09f659494d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aa93cbbde9e9eb7cf1e7055b9f05c5505651d7d12144562edd7df09f659494d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa93cbbde9e9eb7cf1e7055b9f05c5505651d7d12144562edd7df09f659494d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aa93cbbde9e9eb7cf1e7055b9f05c5505651d7d12144562edd7df09f659494d"
    sha256 cellar: :any,                 arm64_linux:   "c0465a09f1dccb5a55c9a7ab5180476632c4f26d8849826bb88ecbbee10349ff"
    sha256 cellar: :any,                 x86_64_linux:  "0dd97735229dd022127f4be649158145c3647d5e4769a3cbbc502e0667e5fd8f"
  end

  depends_on "gnuplot"

  uses_from_macos "perl"

  on_linux do
    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006003.tar.gz"
      sha256 "6499f09a6432cf87b133fb9580a8a9a9a6c566821346b1fdee95f7b64c0317b1"
    end

    resource "List::MoreUtils" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
      sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
    end

    resource "List::MoreUtils::XS" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
      sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "prefix=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make"
    system "make", "install"
    prefix.install Dir[prefix/"local/*"]
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
