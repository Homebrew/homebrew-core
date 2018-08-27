class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iso-codes/iso-codes_4.0.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.0.orig.tar.xz"
  sha256 "771fe4f87997b9c8ff33b6af7f9bde4de87b54410cdebd2742ac6a38cb746a8c"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5002e42bc48087bb4fe89b5e71816c97594a5419d09c057f8ac259c37984bf0" => :mojave
    sha256 "cf5cafde9f48d495c89e65fbc616a555a74d77799ba3300b9bf72486decca6d3" => :high_sierra
    sha256 "cf5cafde9f48d495c89e65fbc616a555a74d77799ba3300b9bf72486decca6d3" => :sierra
    sha256 "cf5cafde9f48d495c89e65fbc616a555a74d77799ba3300b9bf72486decca6d3" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "python"
  depends_on "pkg-config"

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
