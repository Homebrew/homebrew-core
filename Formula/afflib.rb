class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.10.tar.gz"
  sha256 "906226df05d526b886a873367ca896f0058a6221c2e21c900411d0fc89754c2b"

  bottle do
    cellar :any
    sha256 "254150fd3a694e31fe4b18aeb38f6df58f9eb36d47a1dcf2bb31bf3c1d76a4bc" => :sierra
    sha256 "aed0e63b8aa3504075b9a2bbeafb06a0f8813332c32bf0c421604ebf5ea40856" => :el_capitan
    sha256 "9ed21fce9069ccd07e5e87674fcba8c77ef48c24cf1628c1d05a74daf5a417c7" => :yosemite
    sha256 "a81617f0907d054b745d0a0f886ae14fa472193f9722258fa1933854907cc519" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "openssl"

  depends_on "python" => :optional
  depends_on :osxfuse => :optional

  patch do
    url "https://github.com/sshock/AFFLIBv3/pull/13.patch"
    sha256 "dc24b0be3c17938b5b6014ba0fcd885c5f79e758c2150e3727fbda1507cdb768"
  end
  patch do
    url "https://github.com/sshock/AFFLIBv3/pull/14.patch"
    sha256 "3a078e41bd764fd45c5833335f5650f815cbfaea5fce4dca684d270742c3b34a"
  end
  patch do
    url "https://github.com/sshock/AFFLIBv3/pull/15.patch"
    sha256 "e8028dd0ca8573c7d7e51234494782d01d85b1a167b25f12140d5ea21dccea3f"
  end

  def install
    args = ["--enable-s3"]

    args << "--enable-python" if build.with? "python"

    if build.with? "osxfuse"
      ENV.append "CPPFLAGS", "-I/usr/local/include/osxfuse"
      ENV.append "LDFLAGS", "-L/usr/local/lib"
      args << "--enable-fuse"
    else
      args << "--disable-fuse"
    end

    system "autoreconf -iv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
