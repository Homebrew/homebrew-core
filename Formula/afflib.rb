class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.18.tar.gz"
  sha256 "5481cd5d8dbacd39d0c531a68ae8afcca3160c808770d66dcbf5e9b5be3e8199"
  revision 3

  bottle do
    cellar :any
    sha256 "d755c6c85ac762ab789d95d93f2ec5c34f8267ccab2e043e5c999868ddc261ca" => :catalina
    sha256 "be3ae1c09576d63d8a9fbe6b76ae5bdf5d41d6dd8f0d477736878804fb6a8af7" => :mojave
    sha256 "14f7321c3bb680c0410728900fd4dd9fc5a967aed144482fad403d9df1c01393" => :high_sierra
    sha256 "f412d6e0ae58fb1225efe89b9453586fa7cff3ec7bfd8291bd9cda36dd630b02" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    args = %w[
      --enable-s3
      --enable-python
      --disable-fuse
    ]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
