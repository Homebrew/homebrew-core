class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.24.tar.gz"
  sha256 "d42659229b10e066eeb6e81eb673cdd893b672e512d26719c2d95975556ca56c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eab6c5081fee384df0a891a780995fca55f4a08211022f1a341c0bbc952285fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f45dbee0fc2866cdcbe4193f6a3fa00bb65799cc4369c2d228124c05ee39f885"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "953a0fde88d4c6a9439d937a79d9f550f2de4d741c84b9ac7d57e7efa6177199"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c31ffb0275fdd5412bd761e8dd86022073dbe7cb6faaa20527fd5384b0b04b3"
    sha256 cellar: :any_skip_relocation, ventura:        "251c342f16d7387378fd51705322f12c33c323350b82d69c3775f7dbe30da1a7"
    sha256 cellar: :any_skip_relocation, monterey:       "43d1a577db802dcc910b9333c590741f3da054fde7fae60c4aa21a7522348ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c11dd31609aed487688030a795dfb3240bb2e95d85bdd6d14615ce0b84e3911"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
