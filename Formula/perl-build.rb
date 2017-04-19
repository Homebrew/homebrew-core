class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.13.tar.gz"
  sha256 "921880b901ce8322577ae8004cb3214e1223f5ecef0553d02419e7aa265c76b8"
  head "https://github.com/tokuhirom/perl-build.git"

  bottle :unneeded

  def install
    inreplace "perl-build", "our $VERSION = '1.12", "our $VERSION = '#{version}"
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perl-build --version")
  end
end
