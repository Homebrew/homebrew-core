class Multitime < Formula
  desc "Time command execution over multiple executions"
  homepage "https://tratt.net/laurie/src/multitime/"
  url "https://tratt.net/laurie/src/multitime/releases/multitime-1.4.tar.gz"
  sha256 "dd85c431c022d0b992f3a8816a1a3dfb414454a229c0ec22514761bf72d3ce47"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/multitime", "true"
  end
end
