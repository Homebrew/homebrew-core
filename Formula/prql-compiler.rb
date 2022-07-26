class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.3.tar.gz"
  sha256 "f07ba7d735cdb73c37a3f67c97ebfc9b1d54abe6b91a6ee931f733ddd2fa93de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18802d861d4f11cc33621b67cdbca4290a46982e29beec26d107e5bd01b2de4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3b282e30a3ff33887874faabd2fd9db3d9bda5070f8eba985825f2b56f34d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "3684c9b169907a1b3bf18474254801212426d9f6e67e4900d9a88a1a96e98c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "819efa366f783ee03e0bd0f42daea3f08260c8a3221b0db46ee341d11418200b"
    sha256 cellar: :any_skip_relocation, catalina:       "4f207403b24b939275658b2e4fbad0cf40da733bd236d3b873553a2e35a34ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb847f49f14fbd77f5969de453f70123a250b108ce610ac6fad4521a8e25fcae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
