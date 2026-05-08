class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "580e28ceae6a58051f795e638294c5aefa1a0e35708c07a5a2f1de35a8e9cc7c"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64d72f7ace6c13b849a7be2c0aab635ba0e0a7fb5560cbe1469c3c685c49fdf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a69d8363a6ffd87817daec17c8bffb85357e94ab7503f01eca8e02846195a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5395038eb468a6b3fbee81798d9625964972da8069141277af0518ec5770300"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7dfca99b5910b01d643ea794627e4060fd9f8f3a68ba72234481fde261c7fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587722bec1bcd86fd19a8dbc46d66edf42e80233dcdb281788197d6dfaa281e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5906c52c68244e8a81b49fb2a977442e18ffc2496bb757ea89754a510530b07"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
