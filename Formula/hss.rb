class Hss < Formula
  desc "An interactive parallel ssh client featuring autocomplete and asynchronous execution."
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/v1.6.tar.gz"
  version "v1.6"
  sha256 "8516f3e24c9908f9c7ac02ee5247ce78f2a344e7fcca8a14081a92949db70049"

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    system "#{bin}/hss", "-v"
  end
end
