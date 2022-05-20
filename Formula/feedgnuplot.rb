class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.61.tar.gz"
  sha256 "4239fe61a03232ea47909edd59af767b98481b205f58910b2e30d2d41f9caa80"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d921d4a402bdf9ad1633bea40e99f12c746dc671c256c7cfbe54995e2923cb55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87e2ecb32147849148ff6f5519212b48f209abe96a08dc5b5b018d27256b5717"
    sha256 cellar: :any_skip_relocation, monterey:       "d921d4a402bdf9ad1633bea40e99f12c746dc671c256c7cfbe54995e2923cb55"
    sha256 cellar: :any_skip_relocation, big_sur:        "87e2ecb32147849148ff6f5519212b48f209abe96a08dc5b5b018d27256b5717"
    sha256 cellar: :any_skip_relocation, catalina:       "7cfa22c0bd4edf4856f846115e836ac4ac0708ddc4e67c0a1d4234b148f957e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80dc888d48976009f83e56d5395d2db726fbd2e75e9836b68fd33c00af304413"
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

    system "perl", "Makefile.PL", "prefix=#{prefix}"
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
