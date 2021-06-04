class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.4.tar.gz"
  sha256 "9b98fd691670b922c036bac5fcfc1a89afe244eab7d6d1f5689d3a96749876a2"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02d16f2d08342459b63ce8ba7eee9bcde85a85950bec244c9d5827e07f375cf0"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9c74cf305fa4939b7b528a43656c84a6b35d9fd249a29b07a023786eaa20081"
    sha256 cellar: :any_skip_relocation, catalina:      "9e5eccd53d43bb234df114e268b19ef7e12fe31d15dafb11429cdf2305706c84"
    sha256 cellar: :any_skip_relocation, mojave:        "f40c3479f34895f14a902799b4a22d8a246b3d492e58d93e8b4eb268afb158da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
