class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/v1.96.tar.gz"
  sha256 "9cab16a2d9b9e915d7f7299f718d13bb7a8e2082255d29747dc79498d5a4a3a4"
  license "GPL-2.0-or-later"
  head "https://github.com/AlDanial/cloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2ca644c64871c455ca23dbf4bb2a7484a6ae2efc24499137db2ac4f80637410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ca644c64871c455ca23dbf4bb2a7484a6ae2efc24499137db2ac4f80637410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0178f5ea1ba8f6af12d0f3d6922efcef4f36f3b183e0880aff0603f1c4ae047"
    sha256 cellar: :any_skip_relocation, ventura:        "17612c45a4732801fe0a3611fd814126786546a23f9e5a11f19a60fe41f90dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "17612c45a4732801fe0a3611fd814126786546a23f9e5a11f19a60fe41f90dbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ea7874b57b82a041dca9f18e527007ce44a14836468f4b649e3893618c00928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "480db584414f9730082099f836d29a80a7443fa14809d1d01e86c714b50a9cc2"
  end

  uses_from_macos "perl"

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
    sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.02.tar.gz"
    sha256 "c1b2970a8bb666c3de7caac4a8f4dbcc043ab819bbc337692ec7bf27adae4404"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz"
    sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
  end

  resource "Moo::Role" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.005004.tar.gz"
    sha256 "e3030b80bd554a66f6b3c27fd53b1b5909d12af05c4c11ece9a58f8d1e478928"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "Devel::GlobalDestruction" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
      sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
    end
  end

  resource "Sub::Exporter::Progressive" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # These are shipped as standard with OS X/macOS' default Perl, but
    # because upstream has chosen to use "#!/usr/bin/env perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec/"bin/cloc"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    man1.install libexec/"share/man/man1/cloc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
