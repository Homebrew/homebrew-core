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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6446f558a9c5e193e0c96135c9b2e14c83bcedd4e584fdf6768f119936d56f07"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4674bd284ea97c018ae479b439ebe1ec3bf08ca2631e3eb9a27d92479c3bf21"
    sha256 cellar: :any_skip_relocation, catalina:      "0e761e1ac45563693d03501e82ff1a07a865e55453026cda2895650edbeda503"
    sha256 cellar: :any_skip_relocation, mojave:        "e76347d9d442df7f4c2335c277ed801c0e4e947e8d38a9c4e0a3e5bf3519430d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0991c9fc45ebee1696c6f65477cffcf03a1ba88223bbfe95b68bb03eaa87ac9b"
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
