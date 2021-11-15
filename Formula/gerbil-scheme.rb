class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.16.tar.gz"
  sha256 "1157d4ef60dab6a0f7c4986d5c938391973045093c470a03ffe02266c4d3e119"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/vyzo/gerbil.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "e77cbea05b9d1991e02abd6d1ee6a59e623e3a27dd777cde903ef61ad16d195e"
    sha256 arm64_big_sur:  "2961aec56f4dc30a10a944ffb2f7c34d2c725c4e53b3eb5486eaf5d1a2bd92dc"
    sha256 monterey:       "a3078cf9a1a31024c3b62b116893dee942d4c535794c53c40566f01c6c0b303f"
    sha256 big_sur:        "c116f383adefb6954e99e3fc318244f02c30ec0f53e3a7bac135c87e02a90dbc"
    sha256 catalina:       "2e58cb74f57dd09a84bfed13aa1d44a1f1f8f5c057c59d2a27a338950c53ce82"
    sha256 mojave:         "119570c624e9fb56e17df10263434eb0ba94ba3cdbcf5942c10cac9b26161318"
    sha256 high_sierra:    "adb9592baedab1841b1a6603ff8cdc30694b01ecd5444d7c637a987f98356a44"
  end

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@1.1"

  def install
    cd "src" do
      ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra
      system "./configure", "--prefix=#{prefix}",
                            "--with-gambit=#{Formula["gambit-scheme"].opt_prefix}/current",
                            "--enable-leveldb",
                            "--enable-libxml",
                            "--enable-libyaml",
                            "--enable-lmdb"
      system "./build.sh"
      system "./install"

      rm "#{bin}/.keep"
      mv "#{share}/emacs/site-lisp/gerbil", "#{share}/emacs/site-lisp/gerbil-scheme"
    end
  end

  test do
    assert_equal "0123456789", shell_output("gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
