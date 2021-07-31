class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v8.0.0.tar.gz"
  sha256 "42d0acfc579e7deeda57e6c1252165a17b19e2fe7486d2fd17f24adfc2876e03"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fcdb7a40d46c1c39c6b8cc99bfafdc68ccbff182938753e5708cdce4ffb3570f"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d56149acd4bebfce0d827186abe144c82f3e97f871f7528c12d4545a3f45583"
    sha256 cellar: :any_skip_relocation, catalina:      "ae897242f7c94e44db4f2e3776f3620f24b608578f8c38c769dca8fb5f1e0ca3"
    sha256 cellar: :any_skip_relocation, mojave:        "236b14438968d345bb5d97a20b871c9e629170c7f4ff10948f07258740aabbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b640b2cfd5fcaabd5832184e07ce3ae9e6f836a7b41f12aa870f2246b59787f"
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
