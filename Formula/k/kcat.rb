class Kcat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kcat"
  url "https://github.com/edenhill/kcat.git",
      tag:      "1.7.0",
      revision: "f2236ae5d985b9f31631b076df24ca6c33542e61"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/edenhill/kcat.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub. Versions that are tagged but not released don't
  # appear to be appropriate for this formula, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25860a3013a5c54e65ed107ead46eb16dd845230fa7606070c12201c616a5a75"
    sha256 cellar: :any,                 arm64_sequoia: "f684d065bf86b82d9911cbbb86e555033f970923d02bcbadad8073f0601876ab"
    sha256 cellar: :any,                 arm64_sonoma:  "de9642d4f8c58420ffa965fcecd0f220b3f74ecab2944de3cf2aa92b07e698d5"
    sha256 cellar: :any,                 arm64_ventura: "735e7d9bba57e51a819c6db9927425c33b4f90d20df1c5cb4688f661b73b92f8"
    sha256 cellar: :any,                 sonoma:        "dcf579278d9f03b5c59ddb73bfd6348ba8385710bbe01b45ee90bad76d22c215"
    sha256 cellar: :any,                 ventura:       "95536d78ad5b427449953b687b98e18f7cc4fd0b53fd9439849b19970cdba06b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6237b718df72d64eef1d024d565d718ed52c0120996ee8ea165c60796e6e9ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b2ab512dfbe8d359b5002d16066c2a6c2d5dca9f30e0f9e3caf2d49a9270c7c"
  end

  depends_on "avro-c"
  depends_on "librdkafka"
  depends_on "libserdes"
  depends_on "yajl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-json",
                          "--enable-avro"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kcat", "-X", "list"
  end
end
