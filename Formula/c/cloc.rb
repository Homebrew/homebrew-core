class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/refs/tags/v2.10.tar.gz"
  sha256 "a8fac35f4cf42728765580ba11afc2568ad205509a22204663f526169548436d"
  license "GPL-2.0-or-later"
  head "https://github.com/AlDanial/cloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ebeea424f284c38dee5dee3a3a3616a91d12c256e6b15ee7f5b38e459bd93ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ebeea424f284c38dee5dee3a3a3616a91d12c256e6b15ee7f5b38e459bd93ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ebeea424f284c38dee5dee3a3a3616a91d12c256e6b15ee7f5b38e459bd93ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6e69dc850dc0753eecd820ae8f8e546a8ba58157ea56b42583f33406c5cf189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "788294e319ab096390573ba49942bd61625ef741b3fb5510f343447a0b041964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b910e0c4b436a259954e56325baf43988867891164b4e4664ee7e87a0ef2256"
  end

  uses_from_macos "perl"

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2024080801.tar.gz"
    sha256 "0677afaec8e1300cefe246b4d809e75cdf55e2cc0f77c486d13073b69ab4fbdd"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
    sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.04.tar.gz"
    sha256 "606894fc2e9f7cd13d9ec099aaac103a8f0943d1d80c2c486bae14730a39b7fc"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006009.tar.gz"
    sha256 "967282d54d2d51b198c67935594f93e4dea3e54d1e5bced158c94e29be868a4b"
  end

  resource "Moo::Role" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.005005.tar.gz"
    sha256 "fb5a2952649faed07373f220b78004a9c6aba387739133740c1770e9b1f4b108"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Module-Runtime-0.018.tar.gz"
    sha256 "0bf77ef68e53721914ff554eada20973596310b4e2cf1401fc958601807de577"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    C

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
