class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.net/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 10
  version_scheme 1
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  livecheck do
    url "https://sourceforge.net/projects/fuego/rss?path=/fuego"
    regex(%r{url=.*?/fuego[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "8de1559d318e281f40c8223da4f32536fa50858404c43b7285610ad7e66c50d7"
    sha256                               arm64_ventura:  "469cf5bcc73706142f47ffbddfe9974c92a9effa3c884e01cb11300bb2aa3dd7"
    sha256                               arm64_monterey: "0b9d0153bea23d0c117e50bb264f6bce2b7abafc8c9990e9a654606b30894d8f"
    sha256                               sonoma:         "410fea4e6b6d1ec1b36a569e08db7c4d07cbc1d9fe1f4e45c5d3c32253479634"
    sha256                               ventura:        "886fe77a7b33c609517318c17643f590c22d03892d52fcba9d10c1b28a709d0e"
    sha256                               monterey:       "ec491d223f094bb07f9cbb8cdb859038028c2f0e971afda5b1f24b6f10b81522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002811ee904ecf288ee18365fac4d6b7138a1b4eb42e045142c7aec7d6a59770"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match(/^=\s+\w+$/, output)
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
