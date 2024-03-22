class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.10.tar.bz2"
  sha256 "4389a022367ceafb55a6cf7774c5d82d320ec2df4339bae4aab058c511338ad0"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cab1c7668e6151a38324da36e21fc70aebf8d26934aad5c5cb34fbbab409b384"
    sha256 arm64_ventura:  "5cd260cbeb287692c75f6170354ec0ff04aba002fcdcba268eb168d81ababb64"
    sha256 arm64_monterey: "019ec639daf5165a880bbd1d030011efc85dcb0e277834feea42df04691cb457"
    sha256 sonoma:         "afcd9312ae20fc32c373957760205b9ddbce9038568ae619ab99c36ce3051e59"
    sha256 ventura:        "fdefd122edf98e38fc648b57f07b5de2f467d7d84818676e8e214bc931957448"
    sha256 monterey:       "cc69419b1088c7f4974f166b0166e918bb8bc10c0623b35eeb0bc8051c193192"
    sha256 x86_64_linux:   "2d0dd14de1f3a2b056313a6fd054b19be2fb8c04632de7e499519a9ccd53dacb"
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
