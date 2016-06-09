class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.68.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iso-codes/iso-codes_3.68.orig.tar.xz"
  sha256 "5881cf7caa5adfffb14ade99138949324c28a277babe8d07dafbff521acef9d1"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "355fcd7d9f70238d58f29410783d8784f41d2576cc06e3ab3ba2be3abc37ed76" => :el_capitan
    sha256 "7d35d749b7ec99d9437778f012f3add07085405faa888c7861fa39c5cd0725e1" => :yosemite
    sha256 "f2c49b4911463b54b1a0d527064fc4628f98eab13dd03f6938fa5b2ad763eab9" => :mavericks
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
