class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.16.tar.gz"
  sha256 "1157d4ef60dab6a0f7c4986d5c938391973045093c470a03ffe02266c4d3e119"
  license "Apache-2.0"

  bottle do
    sha256 "2e58cb74f57dd09a84bfed13aa1d44a1f1f8f5c057c59d2a27a338950c53ce82" => :catalina
    sha256 "119570c624e9fb56e17df10263434eb0ba94ba3cdbcf5942c10cac9b26161318" => :mojave
    sha256 "adb9592baedab1841b1a6603ff8cdc30694b01ecd5444d7c637a987f98356a44" => :high_sierra
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
