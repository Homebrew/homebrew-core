class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 4

  bottle do
    cellar :any
    sha256 "8f1f7bfced13b9a62c6455be898a72e545f60d6f3c42a7ca9809bb8723ca4042" => :big_sur
    sha256 "399217b0dc94900b41013e73be7ac85cccf52d9046d42d960f0461d07657739c" => :arm64_big_sur
    sha256 "579d10c6b410d1fe18fb653c6413a30ea04f8826f441094bcb944244e9dfdfd5" => :catalina
    sha256 "ed00932e81d23c0a2cb872190088994a190967f4bbe8dc08e9f04212e6ede2e0" => :mojave
    sha256 "3c231bbc8dccff67f8eadb490bb128bbf063e9200993d53d0306e1730ea0bc5e" => :high_sierra
    sha256 "edfae9718df8bd3d4fe6225cca8170513638b1581234fffa8deaa5f9e228593d" => :sierra
  end

  depends_on "geoip"
  depends_on "readline"
  depends_on "rrdtool"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
