class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.11.0.tar.gz"
  sha256 "b216ca0855beefe9cefc58af2ccef6819fc2cf45e1efe50e1e131387f26272a1"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "157728f76b94569abca2c15c768e3baed0603f1c441e03bb2ff0ecd5ecce2593"
    sha256 cellar: :any,                 arm64_monterey: "9b25b2a09255afc3891d0d17ec7ce9e65a1c8b229ac23728e3cc3d0a1fd76374"
    sha256 cellar: :any,                 arm64_big_sur:  "ae5d6c446dbc5bab45e7e81d7dcbab642cca5b0ab928dc3b13d6a34523969014"
    sha256 cellar: :any,                 ventura:        "0385697bf5cb6b4e87dfa0b5121f90961abee68667aadf91a92ea2b9fe4e4813"
    sha256 cellar: :any,                 monterey:       "ac699fd318bf69be10d573acbb5c79d25af63e6fd7d7c8394ea96485ffd08697"
    sha256 cellar: :any,                 big_sur:        "8a2720f49a11a0ab53e1316a7814540f8fcba643045a3a883563e36c612a4888"
    sha256 cellar: :any,                 catalina:       "113d8551f583d7524ae265f03b8f0d1fb4294a4afac7bb22c18f1661349065d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cd1889eb7c180f4e1cb35608d89905168bb98d91f4371d99cf0c4957adc944e"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
