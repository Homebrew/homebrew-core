class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v8.0.0.tar.gz"
  sha256 "42d0acfc579e7deeda57e6c1252165a17b19e2fe7486d2fd17f24adfc2876e03"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22dd85a3bbe42bf3fd00a18d14d105e9631e3ab559cd5cdbf28c5f10cc924047"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a3032b4c8b8b908d052feb8124585d8032ec56ff869f55704e9579f3042a9c9"
    sha256 cellar: :any_skip_relocation, catalina:      "1d9e2b1b14358a022cfac4055b6c132ad775a805db684872dc90922ce313e120"
    sha256 cellar: :any_skip_relocation, mojave:        "65f48f957aa607e3878d0d740a91ed75a22e3eedbe5f9e205a8430586586637b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658ddde90d87b4abf4544690c78e0ddf5679977ec6550e6d2c52bf72b9de3596"
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
