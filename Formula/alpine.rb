class Alpine < Formula
  desc "News and email agent"
  homepage "http://alpine.x10host.com/alpine/release/"
  url "http://alpine.x10host.com/alpine/release/src/alpine-2.22.tar.xz"
  sha256 "849567c1b6f71fde3aaa1c97cf0577b12a525d9e22c0ea47797c4bf1cd2bbfdb"
  head "https://repo.or.cz/alpine.git"

  bottle do
    sha256 "c3df47485dcedfed585bc0dbbb8fcbc2e6eed1494d48cf49a2ee224eba7e659e" => :catalina
    sha256 "fa4a5f8078a26f5390325855dd98eae3ba60ca8c29cdb19ce6828e51862eef00" => :mojave
    sha256 "96c62ab0c3a3f297f015f67add86563a365d77d477a4244588ad2e92d6f95e63" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-conf"
  end
end
