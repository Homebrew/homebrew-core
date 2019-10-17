class Pkcrack < Formula
  desc "Implementation of an algorithm for breaking the PkZip cipher"
  homepage "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d3a30eacefe197d458f08b01ad58d778376fc5b4d53c35f7c0e5c525c17c32d0" => :catalina
    sha256 "43571237e186fe6907bef85b5584772b80ed96b7336e55c47a1b18a41ef75278" => :mojave
    sha256 "13c80200a6a1b96c74c590c595c1860447b04a6bb44d10210d82e0fa53e8f61b" => :high_sierra
    sha256 "264358646b08985192cd06c9bc032c16296eb00198dd9852521e0cfdfe1703ef" => :sierra
    sha256 "9b46e1c0097cc4024d4f5b182ac8fdbc27e3caec52874b19d570aba6f946fc10" => :el_capitan
    sha256 "47f2ffa2e27f0dc5e6df45de7335e316a8ea83288153b274ae5d8e11c7157055" => :yosemite
  end

  conflicts_with "csound", :because => "both install `extract` binaries"
  conflicts_with "libextractor", :because => "both install `extract` binaries"

  def install
    # Fix "fatal error: 'malloc.h' file not found"
    # Reported 18 Sep 2017 to conrad AT unix-ag DOT uni-kl DOT de
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc"

    system "make", "-C", "src/"
    bin.install Dir["src/*"].select { |f| File.executable? f }
  end

  test do
    shell_output("#{bin}/pkcrack", 1)
  end
end
