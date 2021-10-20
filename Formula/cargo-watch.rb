class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v8.1.1.tar.gz"
  sha256 "3da480796a3f586bd1ba3b2c8be24e186ebd95af6c0670bb71eceee9ac7dfb0b"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f6aed6adaad6325af56d4a22d88f79e6e440e92c7494727d61a8af9ecfb20a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "56af6500879866846fcbfb55c046c88558348d40c07d2a84c67dead1e01318e1"
    sha256 cellar: :any_skip_relocation, catalina:      "8a5d75db0356f7953d61108bcfad80a95a068dc373c92437a24e0a5a68d1d560"
    sha256 cellar: :any_skip_relocation, mojave:        "1d92202101624d505bbabb473937bccc69a41c112e0557254ddde85e84a78460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a20bf39e3d0c4d93f4092ec988f0dc39ba75584a003f83e47e1490e5512661"
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
