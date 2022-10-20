class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.3.tar.bz2"
  sha256 "7dbc3e90f2b564d459ccae2195fa201e0b4442f6754f2da2634e172b2ac5e813"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dfcc5e7eae844ac8fb1dc11cdf8f570aa502ecf10514387aa862eafa45e63217"
    sha256 arm64_big_sur:  "eba19ab6306489abe3c47822205cc045eaa4432f5fe6f3328ae84b6c7835bd40"
    sha256 monterey:       "fdbb6827299f2d392b728cb8b1ca8c0b46f740a90e265fb7a7ff209969a845fa"
    sha256 big_sur:        "8ef032a3bc83f64158018d6247bd98c81ac2588cb48c8474a8db390017c79cb2"
    sha256 catalina:       "cb890add706023159e1fd2aa757d72ca0e72887ea30a4a9d3ae915aacfaa756f"
    sha256 x86_64_linux:   "17cdbd67dbcf99083e4a231eebad747f4d86f48cbd6066161a98e5e930e48a47"
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
