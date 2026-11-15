class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "https://gitlab.com/saalen/highlight/-/archive/v4.22/highlight-v4.22.tar.gz"
  sha256 "a44b3a8a02ff58d8e3a42aaa2a477d094094a7d962f2e5cd7ac115d3d7d0c779"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "25ab003f609075f3f80cde8c4481bc5f7df7ed066a99dbb315224abf7e361d01"
    sha256 arm64_tahoe:       "9be8d982574fd2c34401e23df2392694cac7992cd009b92020989606447ca847"
    sha256 arm64_sequoia:     "d345dcaea7b36d45d79c8ab4fcc34498b35ce8c76467a9375ba82316eb43fb90"
    sha256 arm64_linux:       "d81a2bbf7459b90755304393e4f59ba66306afaf9420e872c39b51be5d5d1cf9"
    sha256 x86_64_linux:      "d11a85f2bf2aeadbfdc260f770858285234444bb9123206d4daaf460a868274d"
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
