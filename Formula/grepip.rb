class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/grepip-1.2.1.tar.gz"
  sha256 "e1c838ecac436e744b7808bf3a123be8ce6b72cc436dead64a0a13f409804ea8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65a0fd31909860569cb2b9a1b020aeb04ba22aafdb8959c3af862e6ebcb21e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8108736f9a3c6f0dbe0e8008960f0a964d8440e7801684165605c66aa36a29c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a55b8ad8fe7f08362c67d4b20ff629dc5f01fc611eae577f585a112fcece154"
    sha256 cellar: :any_skip_relocation, ventura:        "05b3ea376ae3efc98375e42bd85b2e28fbc02fbb32730c166df0931b5c3bbef1"
    sha256 cellar: :any_skip_relocation, monterey:       "f3cb1c0121c5f4bbc0df8b3bfcd12cb9b8d453d867f836327054c0dacbb4d17a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5c317e19a7a369b6efde059c43c24b8979af38c00d6f62459dd9064125b1aae"
    sha256 cellar: :any_skip_relocation, catalina:       "d3ba7b84e0c9079a9f9ce2d676c33f1b7733c64de6b8e04a37b899ccf621e1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c864d80756028d055cbd299b05b99fdd336f6aeec276bcdbc3003a2c1ecb4c1d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./grepip"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/grepip --version").chomp
    assert_equal "1.1.1.1", pipe_output("#{bin}/grepip -o", "asdf 1.1.1.1 asdf").chomp

    (testpath/"access.log").write <<~EOS
      127.0.0.1 valid ip but reserved
      111.119.187.44 valid ip
      8.8.8. invalid ip
      no ip
    EOS
    output = shell_output("#{bin}/grepip --exclude-reserved -h access.log")
    assert_equal "111.119.187.44 valid ip", output.strip
  end
end
