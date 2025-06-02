class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.16.tar.bz2"
  sha256 "92261ff5c27c73e7a5c85ab65ada2a2edf8aa3dbe9c9c3d8e82e062088e60e5a"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d95a78c12eb84a96b8c0f86f26732cc3954c3c22ca04e26edc239d4ec1994b6d"
    sha256 arm64_sonoma:  "82cb217618b5972d2db87b0f43c318c1bc8cc8c2ba70727e7c2c2ae32896d438"
    sha256 arm64_ventura: "9a6537b5b06c050ebf31214d45e1eb847a142fd4a5b0ac6a85dcc90a9ebc8d9b"
    sha256 sonoma:        "7450160afce596059f8fa53fbbf5ac8109daa02a0661e8da45e99bd390687a1a"
    sha256 ventura:       "8793ec0f67ab499584dc2b6fdcb733dc2942c4b792f51ef4f8108fdd00d9e22f"
    sha256 arm64_linux:   "74bb1ff6983985224abf7647b6d2f6c1b22eaf2b0a906a4e10142d926b5a2265"
    sha256 x86_64_linux:  "114786274b25fad2abd81d7796f40d38d2e458ece83028fbd0a23b918d56dc2d"
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
