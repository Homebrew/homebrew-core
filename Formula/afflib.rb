class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"

  bottle do
    cellar :any
    sha256 "70a2d09ba44f7a032689728e5d57ca403360a0316a12ddbacb800b36f6f3d5e1" => :catalina
    sha256 "06e421180af02a47847f009f721ca91f7b0d03ed954995a1f12171f9d6467665" => :mojave
    sha256 "172586f837d2cd9dba9b700758ca855e44af02d524d3fc2ce26e693a5006105a" => :high_sierra
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
