class Libmonome < Formula
  include Language::Python::Shebang

  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.6.tar.gz"
  sha256 "dbb886eacb465ea893465beb7b5ed8340ae77c25b24098ab36abcb69976ef748"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "455620731ad9f9bc98ad32c9ccb03965ddfd24aa61bec2a6e38b542f66141d81"
    sha256 cellar: :any,                 arm64_big_sur:  "051b068ad68c55ea65d3baf4d63f93a71022ba23e2aa0de67641d0552a6da939"
    sha256 cellar: :any,                 monterey:       "d88e4c2403568cb058a660889b3217f5b599b1e2c775d50085ad16fc5ca7f4f2"
    sha256 cellar: :any,                 big_sur:        "1b3081ea5174c5152a277459f3f20c6f19bcd9e6fac2383a2500f5252c68add7"
    sha256 cellar: :any,                 catalina:       "dced07a10f36947199fcc4e1caf5a977e0ca3800981ea4a7cdc7c085371fc94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ca287c1aaf218fefae314b503f2ae1b4cd112c37dd317c4fda95106f2284354"
  end

  depends_on "python@3.10" => :build
  depends_on "liblo"

  def install
    rewrite_shebang detected_python_shebang, *Dir.glob("**/{waf,wscript}")

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
