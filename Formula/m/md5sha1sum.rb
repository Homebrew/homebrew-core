class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?md5sha1sum[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "5d30a62c330be15f2314718cebf8e2c4ff270ee97398e0e9c94c99ea32b3e146"
    sha256 cellar: :any,                 arm64_sequoia:  "18eabab184e2ab7e46b74aa8ff7dadd8b88239e604b64eaf64caed43846bea27"
    sha256 cellar: :any,                 arm64_sonoma:   "fdc098e39dd9d37a09189f285bcca2d3c2ebea1820dff398ac5bcb771f82a80a"
    sha256 cellar: :any,                 arm64_ventura:  "1055a4e7c14927621a28916d8847a9d07cd7c2fa3a0b7c5b9a087aa67350fbfb"
    sha256 cellar: :any,                 arm64_monterey: "6c1df5b7a603f00daa2d138d4e71d2f4e61316fb3e5de9f1dd7181a5d197feab"
    sha256 cellar: :any,                 arm64_big_sur:  "8a6b0641375cbc512918fd3b0b79257f542668b5237e2a360a4abecde564bc95"
    sha256 cellar: :any,                 sonoma:         "5f3870382f7bfa8e95a952fb263d0225a6b0405264d1fbcdcdf3c693a9c787af"
    sha256 cellar: :any,                 ventura:        "68dfdf06eb4a9a543477a812deb0cc666688ee28a30e799233501f0855cd1944"
    sha256 cellar: :any,                 monterey:       "db59823c590542e30656a7cc7f2379826352efd07a75e3919f359d33ffed2dd8"
    sha256 cellar: :any,                 big_sur:        "924a214bdfed9ed8f7d9d581bb5717ec6cfe523e0a7f145b3e63075eba244bd6"
    sha256 cellar: :any,                 catalina:       "61cea3dd8aa7dc270e3f5265316dcc73ccafa4ab7caf59b48b8fa5e9208d0d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12341c831b007a3869b399f63e29861fcd1b6929ef852b16944b60614c90c601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0055fc19d2c8072e2e576b7df8de777126f2b5ab2c1269ff224476f8aaf9d65b"
  end

  depends_on "openssl@3"

  on_sonoma :or_older do
    conflicts_with "coreutils", because: "both install `md5sum` and `sha1sum` binaries"
  end

  def install
    openssl = Formula["openssl@3"]
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
    system bin/"sha1sum", "--check", "file.txt.sha1"
  end
end
