class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/refs/tags/arping-2.25.tar.gz"
  sha256 "96f86d0d317c9d09eda183c2f1b7590102ee1798264241377c26bed8bdc0c623"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "73cb4e287549fd6085cdb4e8d3804ee4e0a9559f1cfd64ad54e53f74eaf63937"
    sha256 cellar: :any,                 arm64_sonoma:   "3d35ded0256f623d42b3f2e38bc998211432b1b779a60d6f4433de1398c9600b"
    sha256 cellar: :any,                 arm64_ventura:  "87d1d118843ce11929fa19841c739b1e0191f435d08d7583c9a7115942afc454"
    sha256 cellar: :any,                 arm64_monterey: "537f0fbf6282e143e13cecb4180d3e62450609c53d4ff0eac8e178ae37a2517b"
    sha256 cellar: :any,                 sonoma:         "9188b61bf686f9d25a1fe4739546e390295a0661b0e73c0814a3f12c0f87d757"
    sha256 cellar: :any,                 ventura:        "6922379c216cdadc1f19d9943b0beda7700eb84c19adafd56da4beb81638feb4"
    sha256 cellar: :any,                 monterey:       "496990ab37463fcdfe46e5c357778e0f0a2e1372e2f535a490184bb98a225bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b42edfbfddb3f8595b4ac04addda06675ed0390350e6f70dc990cd59aa847d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
