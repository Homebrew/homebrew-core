class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.16.tar.gz"
  sha256 "1157d4ef60dab6a0f7c4986d5c938391973045093c470a03ffe02266c4d3e119"

  bottle do
    sha256 "0add37e8d09b169414d5d2bcee92b7a538627736bcbf645e2fd98d4192564951" => :catalina
    sha256 "a13389f810deb336907262afd0fcc2ff16dc76d84b3f1c3f34a4ed2420345231" => :mojave
    sha256 "2f666385e995ad74108f9e2477f080a1544c6cbd6a796a014d325190722052d6" => :high_sierra
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
