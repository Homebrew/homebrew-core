class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.4/fwup-1.8.4.tar.gz"
  sha256 "3fb07866e236905de4f66559b06cf73e220fc099807ae19a6ac25a4e36ab67dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9e082864472ff60aed79f941cf1757efc8be6ac5478f283fce1f4f710efc9fdc"
    sha256 cellar: :any, big_sur:       "60e7fa61ed1255184a0369febf79601a27236210b4455d7f2648b5150a85268b"
    sha256 cellar: :any, catalina:      "a562691d96719f33d9d05b6d1aacccd4e67f2dc6e2b4e750e0054638dbb04fae"
    sha256 cellar: :any, mojave:        "5b2117cffd84f70866f52fae62c4f610f133bc5906b8fdfa51c675714165e77d"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
