class Cidr2range < Formula
  desc "Converts CIDRs to IP ranges"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/cidr2range-1.1.1.tar.gz"
  sha256 "db7da678629f43f4fa027a5c9f81f9db32566209c987cc02fe6d5d1d2de02b19"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cidr2range[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43859c5789d878bd51444ce5d13dd36013b83818f85d93c051019b124e8690cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "d201dff9f15ac4300b94749621506bf270d403db91c4bfa6dd4937d233ae0511"
    sha256 cellar: :any_skip_relocation, catalina:      "ec6dafbe0b0e2d4061f5439dcbd43bc1701465bb6040e4960e5b69eceaebd5eb"
    sha256 cellar: :any_skip_relocation, mojave:        "bf0149de83774b10ce61d146e0a21f872de5da126d8346f7058051d30380f26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65457279ad303fd5b98daa30edae82bb710864745b95513ef2631996a4fcb00"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cidr2range"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/cidr2range --version").chomp
    assert_equal "1.1.1.0-1.1.1.3", shell_output("#{bin}/cidr2range 1.1.1.0/30").chomp
    assert_equal "0.0.0.0-255.255.255.255", shell_output("#{bin}/cidr2range 1.1.1.0/0").chomp
  end
end
