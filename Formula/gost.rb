class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.2.tar.gz"
  sha256 "143174a9ba5b0b6251d1d9a52267220f97bec1319676618746c1a5d7a7a86d96"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5112d60ba5a6090f3f3b36d0c59b6400cd24ea07bf03c186de395372b3d0862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fcdb66e5d378771ffb01b848990ab32cdc5447597f5b075f1373023ead4aa72"
    sha256 cellar: :any_skip_relocation, monterey:       "a803beb44f47f36f821f1eb0aa15892d9f95e20431150107c531f3d74fb9d464"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4e97c302058c91679e66f481745d7361045ccf85919eefe3aa8b282d3555dff"
    sha256 cellar: :any_skip_relocation, catalina:       "d032da856ce53e033dea8c91142e8f218b55fb35f3d6e515038fd1256f2431d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7813ce42f66f176ddc7f37aa5db4d466f38d831389bb3e13fe8b591c73c1bb"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
