class Gplcver < Formula
  desc "Pragmatic C Software GPL Cver 2001"
  homepage "https://gplcver.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gplcver/gplcver/2.12a/gplcver-2.12a.src.tar.bz2"
  sha256 "f7d94677677f10c2d1e366eda2d01a652ef5f30d167660905c100f52f1a46e75"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb50587552693b0c0c26ee074c52766c097f90afc6492a0bcf75cc65aaf2f031" => :mojave
    sha256 "2460dcc2da525280cd5b7d2452abe922874291b92f0ba3abd1316da2e5ff40f7" => :high_sierra
    sha256 "a0f14e7d01b7098ed6e770b21df05f03d7506ca0bab3d1f84845ca9ca7d1eb5b" => :sierra
    sha256 "a094d355a75148ed611e9668841a33810a1a1226bc6651b8d0c5e4868867e7fd" => :el_capitan
    sha256 "fc4f5fc0f1bb13139740ae6f2966bd4e3adb57c7a9803b84f946d95fcb40dd2a" => :yosemite
    sha256 "0fc13b457839ee25fc9d0b35338ada6af67d07c8e3fb4ea1ac6f7d454f13475c" => :mavericks
  end

  def install
    inreplace "src/makefile.osx" do |s|
      s.gsub! "-mcpu=powerpc", ""
      s.change_make_var! "CFLAGS", "$(INCS) $(OPTFLGS) #{ENV.cflags}"
      s.change_make_var! "LFLAGS", ""
    end

    system "make", "-C", "src", "-f", "makefile.osx"
    bin.install "bin/cver"
  end
end
