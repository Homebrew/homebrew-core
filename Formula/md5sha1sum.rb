class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"
  revision 1

  bottle do
    cellar :any
    sha256 "d498b282ccd1e70d8676184b3eda51eea4e99baacb92e6d69df2fd05a98d511f" => :catalina
    sha256 "b1dc1ded1df513c24b7eab764707b088f42661c2cf53395e42ee4e03c245ac5d" => :mojave
    sha256 "7ed564b5da0f1adf33c0242bffcd4e456d4e46540b578d3cdb810a9f6a28474b" => :high_sierra
    sha256 "66ff4c578f7eff04b561192dd7789e013714caed61dac322df99f5652790abc7" => :sierra
  end

  depends_on "openssl@1.1"

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
