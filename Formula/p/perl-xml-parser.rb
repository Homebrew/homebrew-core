class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
  sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  license "Artistic-2.0"
  revision 1
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fee3b040b53302d6739156e3fe6ec3d20d4a68976db97596fbc69ae67ca6f478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aaad7520178860c8af99e458d36f34aad602ae20d27321cc87c9d5519ea5bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9126a812628a6ea471ee771981701176e78c67800e2a122682498e0ec1e1ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "437584b3bca0bcb6e71124509c92f2b68e9011d3f663105f0f251c697aa43871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373a53aa2f3d1a8e0de097dc8766f7e5c30212fc2f48a1ac2829aa5de41e54b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9b950e9fe9030de2638c912c2325831376ec6be4a485eb72c76cf9e909f3253"
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
