class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/grepip-1.0.3.tar.gz"
  sha256 "c47da974620700560e0c95a445fc9f0e0cfa2fd192aa88094dab8577c9a6a426"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4eb71156e81900093ab56725a8f8936139f379b342493c706843c14f868260c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "262686a16d0c33db482872981fba872a57d40a0f3c5c87e84eb61ca7209c14f9"
    sha256 cellar: :any_skip_relocation, catalina:      "96e604188f0f2eaaf4071cee4fd71deefcd3600356543d1c62d2e92a3e32cba4"
    sha256 cellar: :any_skip_relocation, mojave:        "4a24e339d049473574048ee2167644ec77ed7f5b965b4f7b02fbcddd98b39166"
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
