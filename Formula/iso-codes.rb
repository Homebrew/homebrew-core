class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.77.tar.xz"
  sha256 "21cd73a4c6f95d9474ebfcffd4e065223857720f24858e564f4409b19f7f0d90"
  revision 1
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d158ff9eaee2d91459e0f792012189c768b4144eed1a643a9d37cdf9c2060745" => :high_sierra
    sha256 "d158ff9eaee2d91459e0f792012189c768b4144eed1a643a9d37cdf9c2060745" => :sierra
    sha256 "d158ff9eaee2d91459e0f792012189c768b4144eed1a643a9d37cdf9c2060745" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "python3"
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
