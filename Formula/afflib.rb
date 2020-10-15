class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"

  bottle do
    cellar :any
    sha256 "4cc737d25010d916fee5998d5409ac803e2051876008602af9e4df5446b820c8" => :catalina
    sha256 "3e533865a44b9cbea70f9e5268fa48828abeb2b8ad864b8b1e3ab8e16c44ce13" => :mojave
    sha256 "09ee4859a479fb096ffa391a21f3e0db65ae16b5953f4a5749ed49219bf51449" => :high_sierra
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
