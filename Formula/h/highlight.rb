class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.17.tar.bz2"
  sha256 "d4f7baa98bd162d8f15642793bd7b8671cfa47ad5100707ac609be3ed486ff94"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "343f80fc682d1fd48c363b8ab191efb2662ce4cd9c6e43655fadb31f0f28f605"
    sha256 arm64_sequoia: "94f2843502337c67babc7ce4be21990ef1fc1ed3ff24847967b71e7c4988b9b6"
    sha256 arm64_sonoma:  "0b871ffd87c3918b8df26b5a4ca6af61db22210ff541854870ee92bf04489ce4"
    sha256 sonoma:        "7a85c8e3c499f88875352cb4682aef9358cdf125f386b0aa2be05c9c27bd0950"
    sha256 arm64_linux:   "d38c3ecc73ff7f51bd820e7e335d871b260e6effce061dd9f645d8dbce18d394"
    sha256 x86_64_linux:  "99dee84c59601cf891420f24fb3e27db25f9ea7415a2e88161ea3ed3f901252b"
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
