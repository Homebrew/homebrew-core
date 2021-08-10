class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.20.tar.xz"
  sha256 "c82141ae2e8f0039ceb0c5c2eda43c5e93ad0bf7f9c6bb628092b3be74386176"
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
    sha256 cellar: :any, arm64_big_sur: "1ae71901f92bc0243151cd785dac4ff217c0e75845300f4f517f47a2cd983078"
    sha256 cellar: :any, big_sur:       "491611eaf26f74f9138776790aa15208dffb96733a172e9ef74359929ce61703"
    sha256 cellar: :any, catalina:      "722059ec140e9e2a900b74075f722c19c982b5e0f2dd7469539655a4604df712"
    sha256 cellar: :any, mojave:        "d70dd69dacff5496c9d1e902b8d58af8197f1351991b7e8932b047ac623cd0ed"
    sha256               x86_64_linux:  "a46374aaf211fbf7114713efed6325e0f27d5c3b6888dd66f2bdeadcde99c506"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
