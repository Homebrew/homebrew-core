class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.14.tar.bz2"
  sha256 "099e0eaf38709fe430108125ad9d35f7aacfa05d5d41ad20f405593b575627c5"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ed7e15c71f210e76bcee8b7416d3223ef80eb780d77510f531af028fdb4103f9"
    sha256 arm64_sonoma:  "e25ed7950bc6d062a6211886e461636f5b1183139129079532bce91a1e238965"
    sha256 arm64_ventura: "2c745cb49540996c23d024155601713c61d5e9828647c8016c620d8ef1c76508"
    sha256 sonoma:        "9e3487bb82f9d4db74309bdd4d869c54d036c6c40d64f672653338720de4f092"
    sha256 ventura:       "965c7e73aefb8d828467df266955039cf86f916122c35fed37e43ffc6e09c641"
    sha256 x86_64_linux:  "aaeab92c78bd62f9b6ae77834bc35244f09c60dbbbaf06d6b6aa4b4bd9a6adaf"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  fails_with gcc: "5" # needs C++17

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
