class Identme < Formula
  desc "Public IP address lookup"
  homepage "https://www.ident.me"
  url "https://github.com/pcarrier/ident.me/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "5e37f2f5b661ebe9731aab8d6d2ecdbea6e2239ea6f5ad1f2b158ea15fea947c"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcc2884b11b9611ee7db60d19784821d87a0ea368454dcfb82f7207dd88b99bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82d1f4cb80b8e2938b98e7f2607790e755f2426ba501b0c3c3168046c87f6bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aaf58663a73cae3a4d7fbadb335ed1b6edcb06650f87ed7e5e866699ab85c03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "477637b5d904ee0681549d058fcfb5a02bc6b567acc4b46e56116aa4e8b1116a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c44759d0efa524f4fb1dd080df603c5e76f07979e20cbd046d67a79f663ad4f"
    sha256 cellar: :any_skip_relocation, ventura:       "4767ff40b495e2121372fa1b63eec1ec3af427349550df21620422071120f023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7374807cd07652348ba7d65f83719f748cca06c79f98a3384ba581ac57e6ed66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6f811abc28c9e9eb8402f34187210d1ee43ad0e915891c57f6a3962b43f22d"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  def install
    system "cmake", "-S", "cli", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "ipv4", shell_output("#{bin}/identme --json -4")
  end
end
