class Kcat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kcat"
  url "https://github.com/edenhill/kcat.git",
      tag:      "1.7.0",
      revision: "f2236ae5d985b9f31631b076df24ca6c33542e61"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/kcat.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub. Versions that are tagged but not released don't
  # appear to be appropriate for this formula, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "91a40bc28ce360a9fa3d40f9a16917cc91e553f13b8cc6bcecbff98827c9d15d"
    sha256 cellar: :any,                 arm64_monterey: "fd220a7e002772622e581f636e59c4a198ec883cbb813d2b31857d0bf24d089d"
    sha256 cellar: :any,                 arm64_big_sur:  "f930080248bb0eff245599536bbc12465c6bf6e256acb283e6d2d5a5d047f11e"
    sha256 cellar: :any,                 ventura:        "7f2f0da947ecd7fd93bea3a0b53d4e2f0e2d51e5bd9f2b93b870c20c22f88e26"
    sha256 cellar: :any,                 monterey:       "5629c17a2d26e8e36c1e7aa8e54430e004e2d7ef080df3ce6ff6edee4a4eb0e4"
    sha256 cellar: :any,                 big_sur:        "c6d947fa5cbdd948ab09082f1c961d21e5a6e565c36cb6ffffdc9712456cafad"
    sha256 cellar: :any,                 catalina:       "7125450d67cedf6116bc7e2afb22be2b860a715dc1de6663e4e75936d7eb466e"
    sha256 cellar: :any,                 mojave:         "f403c10fd0970ed617e43cbf6fa107cac70cba94633e04c47586a586505b7ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954186ec95e9963cafa13f2ec0ac95591adc1a6ab1b82df116468c973c1ba51f"
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
