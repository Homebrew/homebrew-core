class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
  sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4717e726e05f48b5ba27f7167a8cf36d47597042f0cc77123d51967b1df556f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743f65ac327d1c467d9e4f82fa910d19ae383c858073846009aca35322f9e64e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca54e86b76d10069e88fb814728f36ddc091cfda3dcffb38e68c6ec656d05cc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dc622c5856a89a675ab3a23aed3158434a6a7196d9b95b19b82f4371d1f50c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b5a25de8d14214ec9102591fe6812ee2674e0c3e1e6bd2e4f094690298ba55b"
    sha256 cellar: :any_skip_relocation, ventura:       "1f11e49aeb5e4927c4fdd2a3f23096b655b06146a34ac2c3275a0967eccc882d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6d38240ddf5f5c8c1d8a170d3f609e5c575f6218400779d9fee264434b6eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee8525a0657759385a896976246e5e8d65c948bcc81276c6edc1fe7c72a0a15"
  end

  # macOS Perl already has the XML::Parser module
  depends_on "perl"
  uses_from_macos "expat"

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make"
    system "make", "install"

    share.install prefix/"man"
    perl_version = Formula["perl"].version.major_minor.to_s
    site_perl = lib/"perl5/site_perl"/perl_version
    (lib/"perl5").find do |pn|
      next unless pn.file?

      subdir = pn.relative_path_from(lib/"perl5").dirname
      (site_perl/subdir).install_symlink pn
    end
  end

  test do
    system Formula["perl"].opt_bin/"perl", "-e", "require XML::Parser;"
  end
end
