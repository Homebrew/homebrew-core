class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/refs/tags/releases/0.60.9.tar.gz"
  sha256 "558421ccd6aa91d6922dd1baa04e37aa4c75ba0472118dc11779e5d6a19bfb38"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7c48862206356a3de287f28c00be2ab401847f28ae124e7c55daed083d4a95a0"
    sha256 cellar: :any,                 arm64_sequoia:  "a7679c76ba69e2c4c25830db38c6a956c4cf1955fe31ca27ced5413a1652d89e"
    sha256 cellar: :any,                 arm64_sonoma:   "79654b7ed9a9b9c474e4c8bf053e57682176e5efcb63e7274a3c827b306b4a66"
    sha256 cellar: :any,                 arm64_ventura:  "ebf1b7f9467644c64d0baf2ae15736ae7ed7cf676ad31c5bf7f9c625da43f8db"
    sha256 cellar: :any,                 arm64_monterey: "65c034c952249a5363b4558a1213c8319dd5217bf8f717f80122900bcd874dce"
    sha256 cellar: :any,                 sonoma:         "1fda61fd0c019c89b0fe7bcd9accd0bcb9bd197ecbd076b6992d976c1386d97c"
    sha256 cellar: :any,                 ventura:        "f7bf34059c2124bd1de50fbe0278cfb0ca25eb47d76be096ce65dc58da4b074d"
    sha256 cellar: :any,                 monterey:       "38248f24ef74fe3200d8df1fd272def97d964612e2a65d079a9eef3f4ec961cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2fe70eaaab988117b3ef31682155ac14f031617fb0b0c2693655ccbfbdfab509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59464aa62dd9a8016b3b46d99246b734bc9eaee228eaca8aac5c757e709158ad"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  on_macos do
    depends_on "openblas"
  end

  def install
    system "./configure", "--disable-silent-rules", "--includedir=#{include}/cgl", *std_configure_args
    system "make", "install"

    pkgshare.install "Cgl/examples"
  end

  test do
    resource "homebrew-coin-or-tools-data-sample-p0033-mps" do
      url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.12/p0033.mps"
      sha256 "8ccff819023237c79ef32e238a5da9348725ce9a4425d48888baf3a0b3b42628"
    end

    resource("homebrew-coin-or-tools-data-sample-p0033-mps").stage testpath
    cp pkgshare/"examples/cgl1.cpp", testpath

    pkg_config_flags = shell_output("pkg-config --cflags --libs cgl").chomp.split
    system ENV.cxx, "-std=c++11", "cgl1.cpp", *pkg_config_flags, "-o", "test"
    output = shell_output("./test p0033 min")
    assert_match "Cut generation phase completed", output
  end
end
