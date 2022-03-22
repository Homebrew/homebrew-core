class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220406.tar.gz"
  sha256 "cf4433263cc755edfe56be66d206b7ee5083faaaa8b30bb4102174ad73e22764"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b728de08e1e2c41973f0843f8edf93430ed46216efc0b104d3e0b6e17494f0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0c89d617aca9d5a5d0225987e41719b6f032f34000faf97db6bdb2c3af8c9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "b288135572cb5fb1199ee968189a89ef0d74448be56e4d80e712b5b930581e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbc0b1aab03d7b036413eb4a6be8084fb319d8b6c5d81c8355d111f699f251ab"
    sha256 cellar: :any_skip_relocation, catalina:       "8da09299cc60fba16d366c38d51aca7bd5701185f8af73e76ef29ac9ba78b59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23296bb783de2c22dcf68b6da9169a9efe2787bb2b4078c749e5d41101758b09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    assert_match "brook://server?address=&insecure=&name=&password=hello", output
  end
end
