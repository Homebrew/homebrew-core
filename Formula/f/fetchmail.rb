class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.6.tar.xz"
  sha256 "da99f8c573c4d9e63f493c7e24447126aea25b53b4c076ec79266874e29b1975"
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
    sha256 cellar: :any, arm64_tahoe:   "f19a199d1ed656336f51e062aa360aa5d8385d57cb3ff85383f0d8e0e389f66b"
    sha256 cellar: :any, arm64_sequoia: "650b7cd7ecf3c6f1dbfbc1647a2cfed8a4dbe8fc1551ea266601c313d3a629fd"
    sha256 cellar: :any, arm64_sonoma:  "20b7fb1b194c347d6f0f1d2f7bb467722e321e063df047034c6d0c7f240d4e20"
    sha256 cellar: :any, sonoma:        "30adc2bebd73af90e2e04037ab09f9827ed2bd366b982b08ac03791fe670d0c1"
    sha256               arm64_linux:   "d76e98adc6fb8bb49f3d3ae31e3017a4c499918f30d0f4f133aff0d4bdf36015"
    sha256               x86_64_linux:  "9cc25b3725db740398b50d4003a184073d1ccc6b955962217b1524555d870182"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{formula_opt_prefix("openssl@3")}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
