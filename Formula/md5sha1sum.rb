class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"

  bottle do
    cellar :any
    rebuild 2
    sha256 "69a347afe6f31c0c77b7c24cea80057e238d7af759ec2154d4a231c5a5dafe5b" => :mojave
    sha256 "7bf0df78b9d06ef9cee025b92432217eee87eb337e51c1315862922438e65246" => :high_sierra
    sha256 "6407844631c35a9dd03f7de29b811710af572cb0cd61afe6a184ec37ce7b8289" => :sierra
    sha256 "f2f58d429e422e58a4bc58ab872de048bd873c1cdee017ebc0e133440a223745" => :el_capitan
    sha256 "5ff64041e3ce1028522dabfa6e6260d1502033e207434e9d41598259f426af56" => :yosemite
    sha256 "ea565d1739e48e43d36d46a86772e6159fef7c98260aa5d82404f3d2ffea81ef" => :mavericks
    sha256 "f3925bbf60e1b8eaf47fe26cf19d49e61dd9623f891ec62a5500b07dbc186410" => :mountain_lion
  end

  depends_on "openssl"

  def install
    openssl = Formula["openssl"]
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
