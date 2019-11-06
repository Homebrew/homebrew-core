class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.18.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/colordiff-1.0.18.tar.gz"
  sha256 "29cfecd8854d6e19c96182ee13706b84622d7b256077df19fbd6a5452c30d6e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f3ca0480df2c98a43cba77638ca31d85a2450d6a536e3531f65345f42b07e53" => :catalina
    sha256 "63483bb1f9e86ffb85de6c7bfaba178da41e2f4577e58efd3d893d8b66263101" => :mojave
    sha256 "1b381f5726976016f7996abd414eb24b19bfd63dcc7a8a628e51ca4e3507b4d1" => :high_sierra
    sha256 "c4d57d0ae142725bd320600864843ce040457c7652a3e403e1c65a6e53b42afd" => :sierra
    sha256 "19c797b186c5b2ec4e4692a21d25f3c8e48addea3cc8aaa2809cf37dcc0f1100" => :el_capitan
    sha256 "19c797b186c5b2ec4e4692a21d25f3c8e48addea3cc8aaa2809cf37dcc0f1100" => :yosemite
  end

  conflicts_with "cdiff", :because => "both install `cdiff` binaries"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/colordiff/1.0.16.patch"
    sha256 "715ae7c2f053937606c7fe576acbb7ab6f2c58d6021a9a0d40e7c64a508ec8d0"
  end

  def install
    man1.mkpath
    system "make", "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end
