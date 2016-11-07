class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.1.2/onig-6.1.2.tar.gz"
  sha256 "3dcd221c2c89d7c4a44921cc49ee9f4f4948b1e63cd29426b7b412e3f6dfa85c"

  bottle do
    cellar :any
    sha256 "620670d61e2993fbb63800d4e65e7f156cab027e3a912095aa49fc9798a6f488" => :sierra
    sha256 "0d7a3a4871c1c3a5e329ba69714211ab041c1091dd2aecbfa9e0ac6e54317d58" => :el_capitan
    sha256 "c3a78f861d993e7504dadf47f2b6820f935272210ce49457661d165468d9a102" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
