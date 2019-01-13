class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.33/pdsh-2.33.tar.gz"
  sha256 "7368087429d6269f0a6313c406ef38c6a6a947bc003ca7368fc6481b139d942f"
  revision 1
  head "https://github.com/chaos/pdsh.git"

  bottle do
    sha256 "69d61fe9f4a0ba006e4e5061acaee0b1d9da2b66f8b02af74d510ebea2018e34" => :mojave
    sha256 "5fa7e12d3877247c072e3d393efc6e54bb295f9a6e837402c693f3805990a74b" => :high_sierra
    sha256 "d70f3e18351291dcd04bcc6f59d15aabdeec44cee21e1729205ef9862f97099b" => :sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-nodeupdown
      --with-readline
      --with-ssh
      --without-dshgroups
      --without-rsh
      --without-xcpu
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
