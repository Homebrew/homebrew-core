class Lazyrsync < Formula
  desc "Terminal UI for rsync, written in Rust"
  homepage "https://lazyrsync.westpoint.io/"
  url "https://github.com/westpoint-io/lazyrsync/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7ddb32c20688c1e56032207a5ed8edd5db09f9aaaad43741de13bef715bc1a4d"
  license "MIT"
  head "https://github.com/westpoint-io/lazyrsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30d7de71f22280a95c6284f90772ac0903803d17e6a13f12c8c20db9db0e13bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2ae1b54853ff86369ae4a5d9e2951857874b54dce8c46dd91d551734964a6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55fc0b696bc3ff39761a405ce0260c2e026f16bbd3ee527b9ad64b323867976b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d308c5b510760ca7b2a8591026e8676f53dc0a118e8aa11f4cc5efb8d7b54986"
    sha256 cellar: :any,                 arm64_linux:   "97600aae368c08e8aa9fdcbd962ad9d7cc7c1b99d5c5246f0309bb10886ead58"
    sha256 cellar: :any,                 x86_64_linux:  "081d7766296d581960467eccfedd7b5e0c0234d2f8b3aeccb4f9b7d27083e379"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyrsync --version")

    assert_match "No profiles", shell_output("#{bin}/lazyrsync list")
  end
end
