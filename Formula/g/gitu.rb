class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "eb65c9470bcf59ce76f7e73893a2a40302a39fd339af38a746b78c596d80615f"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a5a48a585eb2b259b4765df3e5abcdd07ccf7ed3edccd1cc7cf11f9ff39e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d4d3bd2c0760c705e8db14273ea7ac4fad5afeda1790fba6fcf9684c74fce88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b324b0578a7767123b6dc583dfc5c2f0acd92eff163a995e56a55c3dc6f3c080"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9b0717f0cc0cab86a87fb8586688f254d1397221331c3d4bbdf4421cfe3546"
    sha256 cellar: :any_skip_relocation, ventura:       "666802de4cfe1467f2c7824716be5f6ddc76f698a95861093e701a2bf03457b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42f9a56ee3f331de972bce4060f6986b075674292da4a35340019acd4cb6ae9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf49de50f2a9222931f9f584aa4238a877ae67466644a368344ba44f9613cf8"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
