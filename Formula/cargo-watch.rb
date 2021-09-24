class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v8.1.1.tar.gz"
  sha256 "3da480796a3f586bd1ba3b2c8be24e186ebd95af6c0670bb71eceee9ac7dfb0b"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abe637d30bd6e4cf373682a098468631840f1e1b2013e1b120c34917015ab514"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d78bbf51018fda6b08f0cbda862e247a7633660dd99ef1f5c3e3e2cf9c05b6d"
    sha256 cellar: :any_skip_relocation, catalina:      "6c0ea4237d894e00f8d55c68eedbce81e28ccaf6b801f46abeb28fc23f796753"
    sha256 cellar: :any_skip_relocation, mojave:        "f3000fee4e8083c41bbefc5bbe56c15f1693f05c63662e8d55d24862cd86e0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad68493409f2478db9132ed6a6b9118553801757aec7c08f9bf62965985d97db"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
