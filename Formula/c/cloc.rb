class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/refs/tags/v2.12.tar.gz"
  sha256 "e49b2ccad4c9c80e0c3f2a5c662c4097c73faf9867607a892f8e4c6dd1c7d861"
  license "GPL-2.0-or-later"
  head "https://github.com/AlDanial/cloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1484be94aec7788f40c75432f3d4f1b90c47df99bd43149c68e3d63699e43a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1484be94aec7788f40c75432f3d4f1b90c47df99bd43149c68e3d63699e43a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1484be94aec7788f40c75432f3d4f1b90c47df99bd43149c68e3d63699e43a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "830a06712542e66279af5113d2bc51edb21d0e3d331f9e015982e1d2ed3df77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bca1b040f01aa84bb877a5a0c8149536eac91b10108ff83bca1b29ed16d963f2"
  end

  uses_from_macos "perl"

  on_linux do
    resource "Algorithm::Diff" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
      sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
    end

    resource "Regexp::Common" do
      url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2024080801.tar.gz"
      sha256 "0677afaec8e1300cefe246b4d809e75cdf55e2cc0f77c486d13073b69ab4fbdd"
    end

    resource "Class::Method::Modifiers" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.15.tar.gz"
      sha256 "65cd85bfe475d066e9186f7a8cc636070985b30b0ebb1cde8681cf062c2e15fc"
    end

    resource "Sub::Quote" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006009.tar.gz"
      sha256 "967282d54d2d51b198c67935594f93e4dea3e54d1e5bced158c94e29be868a4b"
    end

    resource "Moo::Role" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.005005.tar.gz"
      sha256 "fb5a2952649faed07373f220b78004a9c6aba387739133740c1770e9b1f4b108"
    end

    resource "Role::Tiny" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002005.tar.gz"
      sha256 "4618ec524618c104dc28a8cc86af129a00cad282aea7f4c75060ba05d4c8f4d7"
    end
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.04.tar.gz"
    sha256 "606894fc2e9f7cd13d9ec099aaac103a8f0943d1d80c2c486bae14730a39b7fc"
  end

  deny_network_access!

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLMAN3DIR=none"
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
