class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.1.2.tar.gz"
  sha256 "6fe6a45c9acddeb2e8baab84f93fc8bdb04e141639859c52715cba7e57665e97"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0db48532635d7015bde870a460c5d09bedf75048b87556607fc6a5123d1e8654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3696d7daecd6532f313d7237eca9318c31917eb671a115377c56e2437af9b1db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb66ff2296c182b357d04612c3f65fc3452f0f3d8923decf8191c293ff4f4957"
    sha256 cellar: :any_skip_relocation, ventura:        "ba0be6030725469e389b3ae7f9382622a0ac1df83e18e1e0bfdfef537fcf0cab"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa33cef9f23a62da08b439a30127e14f226b15de3e740087c083b860a5eabc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f095d5b5a3c90929e3095fdefe165d7204a21b8a5b97d1eba27cd0fe3c6a7f39"
    sha256 cellar: :any_skip_relocation, catalina:       "9b2666059f60483427a6bda3df3f5ed8f4e1bc010acf9f0863a39f383eed6e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9922546a66c9faf2b7dcb08e08a398941d66d564117e5431a62b36063cfabe90"
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
