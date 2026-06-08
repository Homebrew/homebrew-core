class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "https://distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?md5sha1sum[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "8013a477822f150842d3b14ddd72f026a04969505adb651184f0ca20369c10a7"
    sha256 cellar: :any,                 arm64_sequoia: "e27f2dfdd69bc670d68f72168e4899347d78654e7c3d652746a2d21bda379c48"
    sha256 cellar: :any,                 arm64_sonoma:  "8b3c65b4593b58963f1c852ffc776ae156e49c1b8b72c99a90dc1fe58a945c6a"
    sha256 cellar: :any,                 sonoma:        "326c75ca7ea7467bf5fda8010c7dc7ab8c3a41cd641f991cc624fa2039e8a436"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd800177cea84ac0c5be84abfb04dcfa82bed1ec93d09502136e7438efe4c136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3aae935711d36e78aad4dee6d00194087b761e9b0fe43c6a65738445119090"
  end

  depends_on "openssl@4"

  on_sequoia :or_newer do
    keg_only :shadowed_by_macos, "macOS provides FreeBSD md5sum and sha1sum"
  end

  on_sonoma :or_older do
    conflicts_with "coreutils", because: "both install `md5sum` and `sha1sum` binaries"
  end

  on_linux do
    keg_only "Linux provides md5sum and sha1sum via GNU coreutils or BusyBox"
  end

  def install
    openssl = Formula["openssl@4"]
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
