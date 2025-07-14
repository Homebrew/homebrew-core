class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.4.tar.xz"
  sha256 "c859156e9bff841d4d984cb3fdcb8042b6b31789fc3387c2649baa95a88d698b"
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
    sha256 cellar: :any, arm64_sequoia: "daf595c9ee9c4c8b64f534e7db0432f4e514a7087a8a62e287faac4cdd78f0e7"
    sha256 cellar: :any, arm64_sonoma:  "e0d032448a5d853a87042083a7942556c42c13f71eb5ddf32fb6a4562f5444cd"
    sha256 cellar: :any, arm64_ventura: "8986b9ee8c100f0d141144c57d0abe790023d31e5ff0ae5cbd39c19f2b868e41"
    sha256 cellar: :any, sonoma:        "812b774ef6547548f915952f4522b8ca7b7f7be24b749e7fca410701ad973080"
    sha256 cellar: :any, ventura:       "30ab543b6ef257a4324c98bee2f770edc2371c84752b86b8d93ba8ee72b5af0e"
    sha256               arm64_linux:   "a2f7f8c5f56107b456c97e53ec2f1c5abe445cccef609f92e0583dde033412f5"
    sha256               x86_64_linux:  "c0689bb6b80ddad96a9d209e8fc2aec58e48de412f00815a53d49bda0754141e"
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
