class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.3.1.2.tar.gz"
  sha256 "c17df59e038f9f1b0f09aa79944ba572f5c4efcbfe8bc6bc7aae1b40f035abe9"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8a1640efd1db1f3e2ba361363767fe1d5e3ac3b33e419173ee6c4fb9170d7ed"
    sha256 cellar: :any,                 arm64_big_sur:  "bbd87c23aba8fa81dc53fa00db225f421a7026c76828cf4eeaf12851f8fcc895"
    sha256 cellar: :any,                 monterey:       "cd1a2f6724177393e0aa75d7c7bf1bc01977df42197920516b6039b63bfa058b"
    sha256 cellar: :any,                 big_sur:        "808bd9e888adb28862229941a08ad2041172e29b2714a5e0b87c9877714c5be6"
    sha256 cellar: :any,                 catalina:       "b8d4bf24c9060975c0eb5d12f3f4c0da199c79265c4af85f3fb0db5b5d28cffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e0676b4dd6ba95cbd22f21eb58f6643e80c862fb732752f5b7f8e23e5d21aa"
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
