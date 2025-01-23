class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.11.1.tar.gz"
  sha256 "696e50052008de4fa7ab1d818d5b77eb63247eea2f0575114c9592ff9188a614"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)

    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia: "3df7ec97f7ca8e160691b79694a83a51b9083d502aac81f5979e28ea5b19e92e"
    sha256 arm64_sonoma:  "7d6cad1d2735a82a50b9d628a4b2cdc695f00ad619019f27c68e0721a631f755"
    sha256 arm64_ventura: "af424ffb3f1ae124ba47dfa2bd691a1f90d70cf39fc6345b40fe94f386f02479"
    sha256 sonoma:        "a1b7e2e383c9004617890aa48fdd3873783e643e69d4e1976918e5407319304a"
    sha256 ventura:       "6ec73c76802f96ba82df3495a19d0188ce06e25f244c852a1ab9e58a0844149c"
    sha256 x86_64_linux:  "89c40841c0b01e61324d89074a346a3318a9e6eab50561c6407b1eaae02860e7"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
