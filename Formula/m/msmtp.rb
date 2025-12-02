class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.32.tar.xz"
  sha256 "20cd58b58dd007acf7b937fa1a1e21f3afb3e9ef5bbcfb8b4f5650deadc64db4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb73c1d4d6cf6a3eaa9d58dd28e92a3236b7391fae2d952b5905e4b2aaa69f2d"
    sha256 cellar: :any, arm64_sequoia: "c4bb0636780fd6fc1b2fc13590d52b7b9b3332278494b15a6004a9b6dbf3afbb"
    sha256 cellar: :any, arm64_sonoma:  "f7ad2eb8f4e8af3da9ac87aec6cab70ffa98851883b9fd91d10fa3fc8bee6c89"
    sha256 cellar: :any, sonoma:        "48fd217589c9426abb52e7ab4f39f5cb1187cf0deb5771100d8e867d58339f40"
    sha256               arm64_linux:   "f9d5377da5a884596453a9415f0bd97023e0e658c63b99cae4e1055d48576d4e"
    sha256               x86_64_linux:  "d59eb5c9d9210d35fa752ba933abdc5f85f58df3106482273b8f73dec56b5bb4"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", "--disable-silent-rules", "--with-macosx-keyring", *std_configure_args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
