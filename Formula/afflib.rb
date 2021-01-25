class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"
  revision 1

  bottle do
    cellar :any
    sha256 "045dd01683d3c1411e493d72a8b4bcd6e71113386f330254252e5876d702429f" => :big_sur
    sha256 "4ebc86660cab0964031b14ee14a710a8d83222389ba9e263463f7b7610582b3b" => :arm64_big_sur
    sha256 "63075bb1473d3342521c6e29fd1c8c628114cef274ec8b7cc572d46068f19f4a" => :catalina
    sha256 "9a50d803eedfeb45425b1f7a0452e8f7072d87c2b7b5b488dfca6222a18440c6" => :mojave
    sha256 "9367940cd2b04b6a244b00ba0970ab20b23393604689ee45b5b5b2b5274e752c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "curl"
  uses_from_macos "expat"

  # Fix for Python 3.9, remove in next version
  patch do
    url "https://github.com/sshock/AFFLIBv3/commit/aeb444da.patch?full_index=1"
    sha256 "90cbb0b55a6e273df986b306d20e0cfb77a263cb85e272e01f1b0d8ee8bd37a0"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

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
