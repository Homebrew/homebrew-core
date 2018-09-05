class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.1.tar.gz"
  sha256 "e19fb5e01ea5a707e2a8cb96f537fbd9f3a913d53d804a3265e3aeab3d2064c6"

  bottle do
    cellar :any
    sha256 "7207c8a442fc73842141aba18994652a9dcea64813b0e5ad86901a8e9ae026f2" => :mojave
    sha256 "266556f31f0430f41a1d64b3fb96daea2a4804b1a85c4486c5e39de0f2808d35" => :high_sierra
    sha256 "ed39714d275ffb083e29c72b3a5d9142c0a4081fb8c8479950f71bbddbe5d196" => :sierra
    sha256 "b65b947374b703c4473c6f4daa74090181c7372e4b2d663a05890f988605eab9" => :el_capitan
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
