class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.33/pdsh-2.33.tar.gz"
  sha256 "7368087429d6269f0a6313c406ef38c6a6a947bc003ca7368fc6481b139d942f"
  revision 1
  head "https://github.com/chaos/pdsh.git"

  bottle do
    rebuild 1
    sha256 "c80f133bb94886b26100cde7e5a5d4d803484b13bbef75baa7c5040cac81c266" => :catalina
    sha256 "42ec9fa52d542798255edf1caf31918a8d2691fb93e686d124e1eaf858f0f697" => :mojave
    sha256 "e7d4e21f707f4cce26467f056daae591bfaa8fb9d6f373580ce4ab0b0db1e38d" => :high_sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-nodeupdown
      --with-readline
      --with-ssh
      --with-dshgroups
      --with-netgroup
      --with-slurm
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
