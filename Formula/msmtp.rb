class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.20.tar.xz"
  sha256 "d93ae2aafc0f48af7dc9d0b394df1bb800588b8b4e8d096d8b3cf225344eb111"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cc09836a4d4006b9e20e348e2489b7ff94bf3fe0bca96bad7c6524b5398e21dd"
    sha256 arm64_big_sur:  "afdf2c4eab253086bd05d3d17bb4fd9a4e6ec5b1f7278fe045691a42d196d5b9"
    sha256 monterey:       "5b04585e765b4eb238737921a5fd482c5c7f6cb6d50e28401088af359f7ee3a7"
    sha256 big_sur:        "78aa3acd39b6a9ae44490a55990835836cf5b10d3f5f47180d52313f90c334f5"
    sha256 catalina:       "49ef11f00b1ec162a5e6c0d7ab457dd6a9cbfee963bbe5a37a7c65309aaf8178"
    sha256 x86_64_linux:   "6824e305e82046605a01143e3f3dd00ce66ec9a3a71526c24e29026668e58c99"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-macosx-keyring"
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
