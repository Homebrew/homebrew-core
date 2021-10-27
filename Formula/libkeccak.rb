class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.2.2.tar.gz"
  sha256 "ed77d762199e9a2617325d6fe1ab88dbf53d8149a9952622298835e8c39bb706"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ba646f17c5ba7327716839dbf33b1c6ec270a20c9a987bc8e26a1cc9c0bbb78"
    sha256 cellar: :any,                 arm64_big_sur:  "bce1f455cd7594f5f8c9681b54b06fe169ee72acc7825726bbe536405c4eef4b"
    sha256 cellar: :any,                 monterey:       "cbb00c8a160918c4be3dc9d4bd6d73625e58ef3b9215583d59a7f8eef4fc39bf"
    sha256 cellar: :any,                 big_sur:        "57c3066f8d5fd20faff6aa81dfbd926cb60fbdfeacc26770ddfae0f46b6872da"
    sha256 cellar: :any,                 catalina:       "9e1a251941325262eeeb42b3f30404150d794e7a3f223bba1b7557a1458b99aa"
    sha256 cellar: :any,                 mojave:         "bbacd3d46362bb80a2ead391e7f5f614b5be9c89ef3967b1aa287d00e48deba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e84e22d037e4b81b753523341be53590c805682ff723089a00c89e974df250f"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "OSCONFIGFILE=macos.mk" if OS.mac?

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end
