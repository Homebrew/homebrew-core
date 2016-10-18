class Gwsocket < Formula
  desc "Simple, standalone, RFC6455 compliant WebSocket server"
  homepage "http://gwsocket.io/"
  url "http://tar.gwsocket.io/gwsocket-0.2.tar.gz"
  sha256 "dfe02cdc3c8bca02b498dd6e50161f6f672ad74bc05c4184939c118fd18eda98"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gwsocket", "--version"
  end
end
