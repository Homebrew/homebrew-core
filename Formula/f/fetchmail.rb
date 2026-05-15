class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.4.tar.xz"
  sha256 "efe01690d22bda359a579c77e2b0072658a092bff490ec0478a212c6b7d0eb70"
  license all_of: [
    "LGPL-2.1-or-later",
    "ISC",
    "BSD-3-Clause",
    :public_domain,
    "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" },
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3eef14d0a0b0fffc3b2f6ddbec6da2fefe1a90e19fc281ff3411e7de36ea6248"
    sha256 cellar: :any, arm64_sequoia: "d58409b9692beec1b1bdc8ca37210ac4991f3cdef26e947676e95ca487ec70b4"
    sha256 cellar: :any, arm64_sonoma:  "6d7886b25f77b93eb8d7f15a560dc7132399c3ca7595549563667029bcfd095e"
    sha256 cellar: :any, sonoma:        "fa8975f9360b7b42aea87f6845a5ca59f48e6512f5e7ffb82b922bc259b13196"
    sha256               arm64_linux:   "9b6ac5cc80e64d6a57f92f7e0bc18b69fcf6965129a4230ea89c09582ece6cb4"
    sha256               x86_64_linux:  "084fcfb03b211a040733b291dae9b6c11e8c0e3dbdf5a7afcf969ad0710ac89d"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
