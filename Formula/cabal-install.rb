class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.2.0.0/cabal-install-3.2.0.0.tar.gz"
  sha256 "a0555e895aaf17ca08453fde8b19af96725da8398e027aa43a49c1658a600cb0"
  head "https://github.com/haskell/cabal.git", :branch => "3.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "5605a9a7cef6e7615126345ba43b690f16c80aa853c31cc394b0376c847f6def" => :catalina
    sha256 "07896a69965d55253b30aa20470090245ab523a6ee22efe6b10d3b0ffb4a16e4" => :mojave
    sha256 "72616fee2252d33d00e79ecd1778f0f8abffd71e339482dda5927c10d2574746" => :high_sierra
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  def install
    cd "cabal-install" if build.head?

    # bump HTTP package upper bound
    patch :DATA

    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
__END__
--- bootstrap.sh	2001-09-09 09:46:40.000000000 +0800
+++ bootstrap.sh	2020-04-04 18:07:56.000000000 +0800
@@ -230,7 +230,7 @@ TRANS_VER="0.5.5.0";   TRANS_VER_REGEXP=
                        # >= 0.2.* && < 0.6
 MTL_VER="2.2.2";       MTL_VER_REGEXP="[2]\."
                        #  >= 2.0 && < 3
-HTTP_VER="4000.3.12";  HTTP_VER_REGEXP="4000\.(2\.([5-9]|1[0-9]|2[0-9])|3\.?)"
+HTTP_VER="4000.3.14";  HTTP_VER_REGEXP="4000\.(2\.([5-9]|1[0-9]|2[0-9])|3\.?)"
                        # >= 4000.2.5 < 4000.4
 ZLIB_VER="0.6.2";      ZLIB_VER_REGEXP="(0\.5\.([3-9]|1[0-9])|0\.6)"
                        # >= 0.5.3 && <= 0.7
