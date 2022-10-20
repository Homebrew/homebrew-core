class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?md5sha1sum[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "975c34811713cfbce39d2d7627b62e1a026b4e21dec59f7571fb813b31a9d483"
    sha256 cellar: :any,                 arm64_big_sur:  "6d1aa8a6c57e734885363c8c2dec012e52716332706a7695f5d0994e75957fdf"
    sha256 cellar: :any,                 monterey:       "b06863261442b3ca6bce142c3bd0da8333568324bdc3db17cd739114a9001fb7"
    sha256 cellar: :any,                 big_sur:        "c3ce2a7048d5e035493c2f637249da99f726109a9a643498576441c4c9ec7d58"
    sha256 cellar: :any,                 catalina:       "d498b282ccd1e70d8676184b3eda51eea4e99baacb92e6d69df2fd05a98d511f"
    sha256 cellar: :any,                 mojave:         "b1dc1ded1df513c24b7eab764707b088f42661c2cf53395e42ee4e03c245ac5d"
    sha256 cellar: :any,                 high_sierra:    "7ed564b5da0f1adf33c0242bffcd4e456d4e46540b578d3cdb810a9f6a28474b"
    sha256 cellar: :any,                 sierra:         "66ff4c578f7eff04b561192dd7789e013714caed61dac322df99f5652790abc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25d9290972bc2bcec287eb11b91349f3dd0e5db8ad3a24b35874f7715682cfa"
  end

  depends_on "openssl@1.1"

  conflicts_with "coreutils", because: "both install `md5sum` and `sha1sum` binaries"

  def install
    openssl = Formula["openssl@1.1"]
    ENV["SSLINCPATH"] = openssl.opt_include
    ENV["SSLLIBPATH"] = openssl.opt_lib

    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "md5sum"
    bin.install_symlink bin/"md5sum" => "sha1sum"
    bin.install_symlink bin/"md5sum" => "ripemd160sum"
  end

  test do
    (testpath/"file.txt").write("This is a test file with a known checksum")
    (testpath/"file.txt.sha1").write <<~EOS
      52623d47c33ad3fac30c4ca4775ca760b893b963  file.txt
    EOS
    system "#{bin}/sha1sum", "--check", "file.txt.sha1"
  end
end
