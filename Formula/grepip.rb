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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4649b890194c5b7874efc6d38114072ef1ad52f8420bc213e2a9cfd589924a6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "597bcefc2ec2bcd53ec06f69bafba7d9fdc8926fd9c04b833ac0ab02da1464bc"
    sha256 cellar: :any_skip_relocation, catalina:      "de9d0dd22135c02f09364b5f30875ae7d9f32894a33270fd80301ccc53485f74"
    sha256 cellar: :any_skip_relocation, mojave:        "a29a39e9aca3616d9a5400df48b91cdce2c73d91e8475c0d53de41fea4374b1f"
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
