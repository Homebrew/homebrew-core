class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.10.tar.xz"
  sha256 "9e9b6523f08df50a3d3eec75d94d4c0104ee016c0c913baaf8fbf178bf828388"

  bottle do
    sha256 "916386cfdb7771289edfb648b75372b29585a56dda714f302b0fc4c9076e1e47" => :catalina
    sha256 "d0fd649fbc08b89460bcb6c98dfa1d8e52efc158deaa49a50d56562f06a0bc0d" => :mojave
    sha256 "6cf5cbc88fdd14a03d7ae3aa19c4d3b493c6c4ebf10ab447c559630f5b0cdcf5" => :high_sierra
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
