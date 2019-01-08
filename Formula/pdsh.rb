class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.33/pdsh-2.33.tar.gz"
  sha256 "7368087429d6269f0a6313c406ef38c6a6a947bc003ca7368fc6481b139d942f"
  revision 1
  head "https://github.com/chaos/pdsh.git"

  bottle do
    rebuild 1
    sha256 "656fcfbc4e1dd9cd365379556bf558bffb78069f51f0f844efc7f63775d57f90" => :mojave
    sha256 "8e96d1e821e525b0dd2acade7224957db5dcd9b4a6fb1dc90d4dabcd9f4e1067" => :high_sierra
    sha256 "7834800168a6b0bddb5587df934864caf7d6b17a52b319d98afcb857c931af94" => :sierra
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
