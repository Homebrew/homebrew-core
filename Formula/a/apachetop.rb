class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://github.com/tessus/apachetop"
  url "https://github.com/tessus/apachetop/releases/download/0.23.2/apachetop-0.23.2.tar.gz"
  sha256 "f94a34180808c3edb24c1779f72363246dd4143a89f579ef2ac168a45b04443f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b43b64c9b48fdef15d11d7dcb99d20bf65a31c05b36e7468c3e9e8bbd16f3f5f"
    sha256 cellar: :any,                 arm64_sequoia:  "5fca6d39ff40dc897dd1051087db749f0f6921515443fd6dcd1dbc9150847c3a"
    sha256 cellar: :any,                 arm64_sonoma:   "32e56eb605dc205768eeeb8fa3d6bd575dee188cef3e4962e6e62ffb7bfb7075"
    sha256 cellar: :any,                 arm64_ventura:  "83ab9282b83e2d1e56142e673273f8b709944a0019ffc42547be9a50040c6fcd"
    sha256 cellar: :any,                 arm64_monterey: "090134b03c12d592af96aea44192ba384f283ba968d90d267f30fd888599cd33"
    sha256 cellar: :any,                 arm64_big_sur:  "7fa14fb5f2569c2519b97d0ba9be81e3300acefc7439359053569dca949cd20c"
    sha256 cellar: :any,                 sonoma:         "6f1bb6b2163f1738b3ab80f3c4a41fb0c73f50a07cc45a8924b31b22ec355334"
    sha256 cellar: :any,                 ventura:        "4c6d945946d47eed147f9ff9550bb06d00c5c12662d32375a0ad2e1c2a2429d5"
    sha256 cellar: :any,                 monterey:       "d2e4cc231ecfa99b31fa9d7348755322ee8d3370fb7c9bcbf4516397ebf858b3"
    sha256 cellar: :any,                 big_sur:        "14e727f81b2b5960f03a93e15a5fb345c17749deff826170417bc8aa54687dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ee4946ec586338260b8540ae8954f40001f2cd482663f55a9e19f94572756f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12e4f730309bb91ee34bb2972ef2004a979c2a608abb93500b859973994abf8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "adns"
  depends_on "ncurses"
  depends_on "pcre2"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.append "CXX", "-std=gnu++17"

    system "./configure", "--mandir=#{man}",
                          "--with-logfile=#{var}/log/apache2/access_log",
                          "--with-adns=#{Formula["adns"].opt_prefix}",
                          "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/apachetop -h 2>&1", 1)
    assert_match "ApacheTop v#{version}", output
  end
end
