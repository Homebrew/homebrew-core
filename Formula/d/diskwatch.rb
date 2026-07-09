class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "015d7b13f77c63735c96ddf7adf83434adfce2dd001c87277bbc4a35e6dc5689"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12c595840864a7a48a4da63057b7dfd8dfe23e1b8b70a7ab5a0042fcb992bf4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5f273c23ef23887fbe0fea4306d19015d97eba225c052147156350a0eef8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8af6b5edcb365312370e14c1794506072fe1712c416cf79a6afe2ea10f3032d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba520b5a7ff2adf3ca9b312c4d09e755c3abb2750a046137e965175a5d5bd1b"
    sha256 cellar: :any,                 arm64_linux:   "294063bdf4c04f2edac55e9a72c8c9382cf849b205968138320bf295f635956f"
    sha256 cellar: :any,                 x86_64_linux:  "cc915e8f88ae228dc46ee76e864b26fe48ee61cf6aa7b9ce2fff5a1bb8bca4b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
