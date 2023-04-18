class Puf < Formula
  desc "Parallel URL fetcher"
  homepage "https://puf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/puf/puf/1.0.0/puf-1.0.0.tar.gz"
  sha256 "3f1602057dc47debeb54effc2db9eadcffae266834389bdbf5ab14fc611eeaf0"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ba1fc9eecb1a5920c6eadb88fe5c2142bafd356d420356f15afb0a923ef5b3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d6dada2a26fdd71146a6e83b2cd5792af6a365804f5d714171eccbdcbcdc7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9daf26921e00b28187380efab232b5f4d4e02877e258ec6e4e204d446c25cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "34f663287a1e6eccd24478afff1260281cdca68dda5efa9a6211d1aebd6d425b"
    sha256 cellar: :any_skip_relocation, monterey:       "c1afcd4b99802518b7cee90c23225bec8d2d7104efa503c4115830ab51f582e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "590e0087a563c0fa38996f69c80316f95a54a3a788f0e07390ba192db1d67c44"
    sha256 cellar: :any_skip_relocation, catalina:       "cad4c55abee941651ac9e1f203041240aae43b990f3e9efdce7cd9e0342b727c"
    sha256 cellar: :any_skip_relocation, mojave:         "0135ce2eda650af382ccefebc51bce5b83b356234ad02177a311309a1799af79"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e9f5c12dedbca6d80be8321abdea89162af0097d68401b77aadf93605877a967"
    sha256 cellar: :any_skip_relocation, sierra:         "3153e22f42620f0ceb69f11080e6ba113765d7847cbbb2672f30a7a6766db972"
    sha256 cellar: :any_skip_relocation, el_capitan:     "24952b79335eb08d7a8880a16714e6afe3b73a65f5f26c59b106020198c1b3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0dccb5f5a95571338a440abdc6df58db883ad1ce1b4a3ddc8bae95da82be9de"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
