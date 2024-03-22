class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.13/axel-2.17.13.tar.xz"
  sha256 "6af9c0238ca4fb850baa17878de0361868e3ff6d9302298d83c6d26931c28723"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a095f3c098776c43761c65679a2ecc60bd0b04af9c1a94ffd99844ac69661c69"
    sha256 cellar: :any, arm64_ventura:  "ed71aadbb789bd4086726b793259d58b98fcb2c69e6c3a81f5e40f63344a7acf"
    sha256 cellar: :any, arm64_monterey: "d0af2765b6dd17d34e15686bee72c1c7e1a5508944d648a32b2f69c0658f0e26"
    sha256 cellar: :any, sonoma:         "54bd28d46c91a2d5f5b33d15fd4a53ce0ea8233bbf7d3169916dae6ecbcb20b8"
    sha256 cellar: :any, ventura:        "a88772cfeaef859f51518aacaac3a886944787294ab729acf7197ac7561ff8ab"
    sha256 cellar: :any, monterey:       "c8b6cf0e29ee3469bc13dc2a92f8a18d758aee32cc1e153163919f46aaf5e1cc"
    sha256               x86_64_linux:   "5ee8ef570387c5ea1c14b0dbf4dbdac3bb202b9bc522e9a5d3f5030b15c7791e"
  end

  head do
    url "https://github.com/axel-download-accelerator/axel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gawk" => :build
    depends_on "txt2man" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
