class Hss < Formula
  desc "Interactive parallel ssh client featuring autocomplete and asynchronous"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.6.tar.gz"
  sha256 "8516f3e24c9908f9c7ac02ee5247ce78f2a344e7fcca8a14081a92949db70049"
  head "https://github.com/six-ddc/hss.git"

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    system "#{bin}/hss", "-v"
    system "#{bin}/hss", "-H", "127.0.0.1", "-u", "root", "command ls"
  end
end
