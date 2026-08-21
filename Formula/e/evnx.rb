class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "00fdccff473c51c26f2184d02cf249da2d5b973381a32e41c8049501ee554f65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42dae3897b04507b5b399fbbbebe35ae555568db249973d17700b87e258aa919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b6424d5bf74b165c563c395504074b17009a36009b59cdb56fab780b9507453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39a4dbef29c2f0d350c5e8dd8e5f65fe43004f787a9219e864c32da661c85aa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b27fd4c9042cb39600b129e1b0e754ce5b1f8d6563d9bdec19471c3ed6bf86f"
    sha256 cellar: :any,                 arm64_linux:   "1b5b22d1c6c9804ffc2556f3db58e97a8f9157686efd33e497dc43a376a77048"
    sha256 cellar: :any,                 x86_64_linux:  "506cd3ed6458721fa6c262db5c4825e11a75017019dee17edbd0dc61de8ba0bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
