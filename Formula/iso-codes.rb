class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.72.tar.xz"
  sha256 "d0bd4785c3ec564a966c5792a4e15d119bf1c4dda10e2e60ce9107da1acc44c7"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5295dfee9216b6051d77d911e4255396012f93b929e9df57848048b2c777fc9" => :sierra
    sha256 "e03431d346188c1c00961d5c027b246f75906dcf0dafa5d6496c866f8b087303" => :el_capitan
    sha256 "e03431d346188c1c00961d5c027b246f75906dcf0dafa5d6496c866f8b087303" => :yosemite
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
