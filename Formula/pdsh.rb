class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.33/pdsh-2.33.tar.gz"
  sha256 "7368087429d6269f0a6313c406ef38c6a6a947bc003ca7368fc6481b139d942f"
  head "https://github.com/chaos/pdsh.git"

  bottle do
    sha256 "82769b0edd10de8fd1bd4d5b8968589b691e7bd567627bad51d079c6e363a5e3" => :mojave
    sha256 "d5f3224c594de679ee23cd87faf41371decf42083026925b70299690d3d93437" => :high_sierra
    sha256 "2c3294c33073829999df1f6c5c3a1c179375781170234a72cd4344fd989582d1" => :sierra
    sha256 "73f9503afaf38dfbdb91ad6ac18098fc3676396c2d5a16a8a1dbba0dda2e415e" => :el_capitan
  end

  option "without-dshgroups", "This option should be specified to load genders module first"

  depends_on "readline"
  depends_on "genders" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssh
      --without-rsh
      --with-nodeupdown
      --with-readline
      --without-xcpu
    ]

    args << "--with-genders" if build.with? "genders"
    args << (build.without?("dshgroups") ? "--without-dshgroups" : "--with-dshgroups")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
