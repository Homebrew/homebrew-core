class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.41/src/nspr-4.41.tar.gz"
  sha256 "c562b8ddfe93704b7dc077be013f01448fdc6c124b1821c0f10471a71cb2e9e6"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    manifest_sha256 "ec88784a779d79a74d0bd409aa47d071738c61871a4a60d905b4501e4eae2c36"
    sha256 cellar: :any, arm64_golden_gate: "25b9cc4221fb34c3af7c5c60e4dd3c647dc01699dc88dc65eaf552b7ed7fac4c"
    sha256 cellar: :any, arm64_tahoe:       "3a878872def2d80cbb89df3950554a493f31fe9e93fc2fd8e1c066cf663e2fae"
    sha256 cellar: :any, arm64_sequoia:     "2623e1272ea3b2ecf96f1cf678fedde3c5d91cb46a7a51c544dea3c7db581a57"
    sha256 cellar: :any, arm64_linux:       "237555dfb50937ab0ffc153e463e203f34dfaa22207aae7dc40be9c2a7ecb210"
    sha256 cellar: :any, x86_64_linux:      "a56e5253473c3b24d5a4743a044451853307c5e9738108c169062d89ceb857da"
  end

  deny_network_access!

  def install
    ENV.deparallelize
    cd "nspr" do
      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-64bit
      ]
      args << "--enable-macos-target=#{MacOS.version}" if OS.mac?
      system "./configure", *args
      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system bin/"nspr-config", "--version"
  end
end
