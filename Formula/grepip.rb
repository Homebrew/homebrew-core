class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/grepip-1.2.0.tar.gz"
  sha256 "f29db57e7288d2f1e71776de88dd6445524028586997454a8aa300b1aeec632d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f13b8f833819048b9f9a3b3ae9b06ca2d0f048d5946964713071ce1f24f8b43"
    sha256 cellar: :any_skip_relocation, big_sur:       "69ca00dbdd25023b426d3dd90c8ed781912ed93a1c22e4584ff63a87db486152"
    sha256 cellar: :any_skip_relocation, catalina:      "02a9c78883ad37d86b44c1adaeb45941824bb150d6f87f7fc5858f1ac7544db3"
    sha256 cellar: :any_skip_relocation, mojave:        "c862c4990834b88e3b069bca2d916ee9f27ff15e8a9b5029658ae170f25e0bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c7ff3e474306572d0d62c8b3afda99d755b6794c0045e8de2908277c5689b6f"
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
