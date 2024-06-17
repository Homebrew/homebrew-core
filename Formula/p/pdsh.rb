class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.35/pdsh-2.35.tar.gz"
  sha256 "75ef15347848fff43f8d6ff9c4424fe05c7dd2cdba029139901f861a05093cfe"
  license "GPL-2.0-or-later"
  head "https://github.com/chaos/pdsh.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "e00a802e4fbdbbe512b3222a15da104ff75a5f35beb28fed5a6239f9b4cf0476"
    sha256 arm64_ventura:  "ee17c95f1182a9899b11c65a05f39286abc414c4cc66407d0f0f05a262ad81a3"
    sha256 arm64_monterey: "a22ed5d817733ddbd02889fe279f1350420deca549a2aaed17c6bb58918855bc"
    sha256 sonoma:         "9cfecd506b0bf86abf5fc01306ae1e17f669e536bc8c07fd09398ca88e4ac12a"
    sha256 ventura:        "942f58f439d6a63a936970bc1e04f02bdb70b11d987a818ea5a286ff13d8bec5"
    sha256 monterey:       "b6cabdcc2b823e830a774349cb1fdf26d5e3a85977c6e21b27e5447b86e83b8c"
    sha256 x86_64_linux:   "497c73313e668ccff797d0c3ac567ee964e0970d31488185b8788f0812626e36"
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
