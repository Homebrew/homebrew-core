class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.38.tar.xz"
  sha256 "a6cb4ea863ac61d242ffb2db564a39123761578d3e40d71ce7b6f2905be609d9"
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
    sha256 cellar: :any, arm64_sonoma:   "2d775ce9c19eccdfeb58d46cc2aab3ecd47bf87a05c23fefb541f117a5b40aa1"
    sha256 cellar: :any, arm64_ventura:  "c33370a7017a00672e7f0577a6390db772510b663610fcdca10b6442775eb72c"
    sha256 cellar: :any, arm64_monterey: "e8e16009d132a00fffe6b2ab0622236dccd1bbaa64a58a5fbfe015cc89dbff91"
    sha256 cellar: :any, sonoma:         "d542f2329397590e1a9657cc57065b35b8a3cc4d33d2de0ed8088a0aad894e9f"
    sha256 cellar: :any, ventura:        "87a1c760bb79b966bd9bf49fba80acaabc2f86d3f0ac8c3f195bc05a981e7523"
    sha256 cellar: :any, monterey:       "6690cb4dee60fab79eee8527e7aa3e12e439b2077abd4b588e326ac680faa004"
    sha256               x86_64_linux:   "bc14e4efa6cf22c862f38082fd58a8dc3149c3fdf2d5f26bb92a2c465bb4afcc"
  end

  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
