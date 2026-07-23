class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "427c47527f11d157380d90e33c86535a3a0e8eb5c7e2cf0278bd6dbfe733fcee"
  license "ISC"
  head "https://github.com/fragglet/lhasa.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd1ffebee313b2d3aa6c6290799c925366393b65d8f45964c2a96b8617d135b0"
    sha256 cellar: :any, arm64_sequoia: "354461e9807d52d9fc075852b346a442b3d51083e4c6f07a9b21e5116aae696b"
    sha256 cellar: :any, arm64_sonoma:  "8a483eba2d6c1f8d8c1270c14bf353e1bc8821f19f365c22f27a28e365337dbf"
    sha256 cellar: :any, sonoma:        "315001623b16e7fc445f30c7ccc0385868f3c1069fc3b896508e70f398472bd4"
    sha256 cellar: :any, arm64_linux:   "b332860a7e3cd46ce891f033ffa13c36f69750b6a5b268ae72ae752838944fda"
    sha256 cellar: :any, x86_64_linux:  "0c129f9050e1f622e7cb01f5a4929c2344e5d8e8916b2bba4d5be5e41261d982"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    data = [
      %w[
        31002d6c68302d0400000004000000f59413532002836255050000865a060001666f6f0
        50050a4810700511400f5010000666f6f0a00
      ].join,
    ].pack("H*")

    pipe_output("#{bin}/lha x -", data)
    assert_equal "foo\n", (testpath/"foo").read
  end
end
