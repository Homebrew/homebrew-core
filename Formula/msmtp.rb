class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.4.tar.xz"
  sha256 "e5dd7fe95bc8e2f5eea3e4894ec9628252f30bd700a7fd1a568b10efa91129f7"

  bottle do
    cellar :any
    sha256 "08f80b3e19167436903b1d1f4f967e57cfdd41aca8a335b0837d46c67aca9f86" => :mojave
    sha256 "47e8e6a151a310438507162258850a02cc7a86540ced579596484bfd3e4b2f63" => :high_sierra
    sha256 "9cbb35af98b6fa957726dc08baab05a4acf6c509416affda39718f10ae4b8576" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
