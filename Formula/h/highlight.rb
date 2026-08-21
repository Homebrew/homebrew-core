class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "https://gitlab.com/saalen/highlight/-/archive/v4.21/highlight-v4.21.tar.gz"
  sha256 "b41e0b00f75e642dcc85144e04a6893aa0aada502d5d482c06462610e3078590"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0cfe7cdba40aaf8804ec9fe92470c40b7c9b881857bcbc53fb671fd54b12ca85"
    sha256 arm64_sequoia: "a1278c2a0ec425a01a805f56b6b1b139eb54325ca7984360788a80f17bf4b431"
    sha256 arm64_sonoma:  "36bf8fbb525031efa58611cd030f984320c13839b755cdb38deea83b6f3060fb"
    sha256 sonoma:        "38a3159370697a8ba9537258daecb2be8ad849354650352bfda76fb367bc750b"
    sha256 arm64_linux:   "2aed8aeaf9c91c1d29aadd0df427f924afb59bc04f723de3093e364dc86baa9d"
    sha256 x86_64_linux:  "540c5f14c1369f466bd5d29ee178bae88a1a47025ea567de01154ba902ea0567"
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
