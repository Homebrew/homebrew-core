class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.15.tar.bz2"
  sha256 "68b3f8178c5c9d4b0a03f6948635cef1c8d06244f6b438eebf3a190c588337e9"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ff999afeca53826467b3b2ffd96e65716fa8a8e51a59c9be07666517828f93e1"
    sha256 arm64_sonoma:  "5d3477115be405359748090729b3ebfe31cb9dc0811fcd5655789527a4b52fba"
    sha256 arm64_ventura: "3555236122462cedf6214f1f16f29d8867351fd3769fb3bcbfc7bed2af8f4476"
    sha256 sonoma:        "171ae8debcdaeb6f04cd6a591c18b5edf12481334baa35fd5e6d88a25e85ba5e"
    sha256 ventura:       "3b72f161f5978f8c565fad920a41252ac17106e79ce342984a80ffe0caaefe00"
    sha256 arm64_linux:   "a1de5fb88c5ff05d3977173bc2901ad2dcbdf8311859a9d4f21f681262a07586"
    sha256 x86_64_linux:  "52594457b5a8a77269f061bd6fae2a973afcba2b71a91a285d57de2dbaf135a1"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
