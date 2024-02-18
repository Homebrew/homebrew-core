class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/refs/tags/v1.62.tar.gz"
  sha256 "7a3854c3620f7cc6bf5bf13546f5e8cbead2bb1afedd455b9ecabf367a6e78df"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c786d208bf90d15994a7a5b859011f609f24566f95a391282d5d0165a2e9a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f9e9864b476ed173d64685c560ad0fef12ee1c1a34b8a327ec18eac76d9cea4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f9e9864b476ed173d64685c560ad0fef12ee1c1a34b8a327ec18eac76d9cea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c786d208bf90d15994a7a5b859011f609f24566f95a391282d5d0165a2e9a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f9e9864b476ed173d64685c560ad0fef12ee1c1a34b8a327ec18eac76d9cea4"
    sha256 cellar: :any_skip_relocation, monterey:       "2f9e9864b476ed173d64685c560ad0fef12ee1c1a34b8a327ec18eac76d9cea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf6086004f0dde7ef683af3389c7c28352bd24705d4216bfae9d1ba1184db53"
  end

  depends_on "gnuplot"

  uses_from_macos "perl"

  on_linux do
    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.002002.tar.gz"
      sha256 "00f0b95716b18157132c6c118ded8ba31392563d19e490433e9a65382e707101"
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
