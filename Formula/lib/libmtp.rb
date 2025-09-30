class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.22/libmtp-1.1.22.tar.gz"
  sha256 "c3fcf411aea9cb9643590cbc9df99fa5fe30adcac695024442973d76fa5f87bc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb7e77219550018cb1e31ab3335422a448155721313084dea2acbdfb827f865b"
    sha256 cellar: :any,                 arm64_sequoia: "1142786084849b45e771a43aeb71e026fe248539172a196067679ff794eeb2fc"
    sha256 cellar: :any,                 arm64_sonoma:  "70073e53b78c742bb5270a210a9abd301a14ec61938d4c73b0a71105e84f4d3a"
    sha256 cellar: :any,                 arm64_ventura: "122bcdc9ef407c2395f4022f9bebed02d4bf29eeebdeea7791b7f5fce1d7ddf7"
    sha256 cellar: :any,                 sonoma:        "5c8a42810b2c8e462121c5a30b9f416d88b36854074f05c361a29a8b2c8d9691"
    sha256 cellar: :any,                 ventura:       "5b5b1a0918987fb736d910a8b9153cb81c9a8f059ed5bd70af6fa19c18160695"
    sha256                               arm64_linux:   "096547e52a494fd59d2d61b4a1d23e15268e05c0d16bf546f2f861364ad04e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa88301d0fda571bdac1fee606be3dae4a207a403c658592f9a914f53c9e9579"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "./configure", "--disable-mtpz",
                          "--disable-silent-rules",
                          "--with-udev=#{lib}/udev",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
