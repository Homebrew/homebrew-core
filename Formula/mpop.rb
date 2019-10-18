class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.6.tar.xz"
  sha256 "fba142b133662c4e1d5587c96ea7d024a754584df64c8cf16e96bd40f7779160"

  bottle do
    sha256 "ebee77370afb55e27e025b8b954334d70fc9c6d052033a30c3968be796eaa248" => :catalina
    sha256 "71b45b62a099afa9bb44aa958e2318771e1c1851efccb961aa558629b0e2229e" => :mojave
    sha256 "52f8ea2f987b39b13845c224d6704f6623f9448ab9cce699874ed657e5b19410" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
