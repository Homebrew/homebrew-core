class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.21.tar.gz"
  sha256 "79ebd5cf965e7eb127bd33109d83d5b34226d5f0d039a505882d8d20f72deb3b"

  bottle do
    cellar :any
    sha256 "0ae9676373ff11d14f39f5c0a7e517378caf6ba13a67606d12709a7fb4e45d02" => :mojave
    sha256 "bad5f2f612c39249aa79c59bffb3f00ce8a0ccfba53a736ca59be2532b58ae89" => :high_sierra
    sha256 "8eb5123844700c8c85cf6c83997bc6a02e8f7c69295ecdb8d3954a5b1dfd6ba3" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
