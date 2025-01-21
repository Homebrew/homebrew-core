class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.2.tar.xz"
  sha256 "8fd0477408620ae382c1d0ef83d8946a95e5be0c2e582dd4ebe55cba513a45fe"
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
    sha256 cellar: :any, arm64_sequoia: "50d4e5f30efe550d1ef4347f0c462c1361253ef3440861132106bbfa9fbfd6f2"
    sha256 cellar: :any, arm64_sonoma:  "4eda9c11eaa05e24837a30f5fd682e9cb190a923356e6e5d1c6fe74f76ef06ea"
    sha256 cellar: :any, arm64_ventura: "49823e15e65d008950bfece7216bb4d745c80edeb15b56cfb719719cd26b37c1"
    sha256 cellar: :any, sonoma:        "03319b40971cb573afe7d0e3492065f811937d4e3a0ff2203bdb33fd85f5b5a0"
    sha256 cellar: :any, ventura:       "e6c5aeb3329d1e2e4ca9a936cac0ee14365b5acfd8bca476e21cb85823a67b50"
    sha256               x86_64_linux:  "b27f94a8b07b2724bcae268a396cba7cf1549a186c32edee811b3142eb822439"
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
