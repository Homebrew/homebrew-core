class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "https://gitlab.com/saalen/highlight/-/archive/v4.19/highlight-v4.19.tar.gz"
  sha256 "0f243a9fb72da88148db473c9411c92c4988bf940bff32eef939bc1efa0017c8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "09dad42718a031b6011aba60b8bbda5be24c7dcc4223fd7a7bb829cea0cd8958"
    sha256 arm64_sequoia: "bfdea43d9d24a24049cc36c5661c390b7f6dbf9b1951fda6fcfab22cc96208b7"
    sha256 arm64_sonoma:  "91b1d3a9793acd5acca691df1257cf79a382a74a4034b0e3d182bea835e7c1b4"
    sha256 sonoma:        "bad596ecf324c720b426eac935f1ae9658bd05a445bbf6589630169841466673"
    sha256 arm64_linux:   "0264064075facd93f54f6c58932e47a31462282923b8fd3c6735a9306464fbc2"
    sha256 x86_64_linux:  "4355a199df0f0bf391283a5917a1fe505ace3cfbcf72649862d6dd0432b5c063"
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
