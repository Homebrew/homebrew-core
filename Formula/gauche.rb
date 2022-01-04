class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_11/Gauche-0.9.11.tgz"
  sha256 "395e4ffcea496c42a5b929a63f7687217157c76836a25ee4becfcd5f130f38e4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8c6ee9a97abc1cd34a35c4dc7b80c194b27958651a111d70361938e911e0b2f6"
    sha256 arm64_big_sur:  "e262583921236d23c34f8b89fd2dc99b2ec6327373dd35ab5f37e0330a320dd6"
    sha256 monterey:       "391309c0262e859a5e772a028ac99b1bbcf7843d0682f43375a4bb362fabfed4"
    sha256 big_sur:        "f93b45e4f199a4fb9ee25ded29082e4c9767220585dc0a43969e60f6317486ba"
    sha256 catalina:       "02cbb6fbdf878cbef1ef8bc74c2aabbac1452dc28a105fdd053132b12a204ea8"
    sha256 x86_64_linux:   "acdd9cfb5dfc0457c8e8fc02a359462426d7ae814ec47343389395172983e6fd"
  end

  depends_on "mbedtls"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
