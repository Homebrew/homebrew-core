class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/grepip-1.1.0.tar.gz"
  sha256 "297e969f92e3fd47137d6ed6313d00245611a850a17f139f07d6d536969014d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "447eeb29e7bd5f931ea23b35f469de5b0b6f470b801006f36e703ef266d9cc3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "93b99aeb650377891af7d77c56a4d2a5f8333e992c956feee8f3279cd19da622"
    sha256 cellar: :any_skip_relocation, catalina:      "799364ae680994843df8998cfd5cbb991e80c7a8eb921923dc688f9811e4d320"
    sha256 cellar: :any_skip_relocation, mojave:        "28b4231e5188775b6e017f96c5d8e90259c78e2a35c0d720f0a7aede49179423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4e72268a715af939920c984c89541a78d60e2113d9ab5d1929c345f91035d3"
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
