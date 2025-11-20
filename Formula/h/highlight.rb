class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.18.tar.bz2"
  sha256 "f52c211dcd5626526af45ab8e558253caa713d060709bbac22c23ceae35eb502"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b7bc2c315a4cbd6b3a554e262b70fc791b63aeaa1e8c30c8e4b20f599735a6ee"
    sha256 arm64_sequoia: "c1eea02769cfb70b9dd43e7ebfdda6ce6398991cd502eb177979023dc4ee3bc1"
    sha256 arm64_sonoma:  "e7b04a22f602c64fea6b91ded206032f0d2956ed4d871c69b6f6a13b14a7cae5"
    sha256 sonoma:        "a1990a784a71909c7f8203b0054a6d9f9d34eb2e72404c083e6f4a9c540b7672"
    sha256 arm64_linux:   "214013dba2de9615dbe241bb7b0dead17d226c6ba653e28435d92f38a04b9b1b"
    sha256 x86_64_linux:  "f6572d3b44fa376ede8a608a44977a96e1933011e139ca8c7f13b5d6a0bd61b4"
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
