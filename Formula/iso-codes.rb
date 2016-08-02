class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.69.tar.xz"
  sha256 "3f285d3c13f4dccfbdb9e432f172403ac1a54ab432616f10556eb18c23a1c0b2"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb38fbb6bfc4bcbd59ada407c9a6b663ed9f8e0a01a506416b4f6ba315a578cc" => :el_capitan
    sha256 "c1bf7781494f264022d1dcb2fe92546d79d72cc91db2ef1038d44fa02c0189ad" => :yosemite
    sha256 "9bb54a571569d2d19e5a74f22f53ef1dab7de5bd7c760eb31736cd9faead4bb0" => :mavericks
  end

  depends_on "gettext" => :build
  depends_on :python3
  depends_on "pkg-config" => :run

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    pkg_config = Formula["pkg-config"].opt_bin/"pkg-config"
    output = shell_output("#{pkg_config} --variable=domains iso-codes")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
