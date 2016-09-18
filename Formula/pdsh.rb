class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://code.google.com/p/pdsh/"
  url "https://github.com/grondo/pdsh.git",
      :tag => "pdsh-2.31",
      :revision => "e1c8e71dd6a26b40cd067a8322bd14e10e4f7ded"
  revision 1

  head "https://github.com/grondo/pdsh.git"

  bottle do
    revision 1
    sha256 "a1646861fa1ab99188ba0de4f34ecccb2ca83ed903ba3a35fd2cc3d401f4bf68" => :el_capitan
    sha256 "0dff88e9e6a412c89c40f9665ff00d254dd87faedba40abd8921fcfd0f6c49c8" => :yosemite
    sha256 "2460e8f10a6b489856425c7b212221dab8b12afa1940ffc8741f69a21a5436c5" => :mavericks
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
    args << ((build.without? "dshgroups") ? "--without-dshgroups" : "--with-dshgroups")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
