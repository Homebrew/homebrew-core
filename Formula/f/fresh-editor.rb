class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "2573f69ae949074b7b1debf286c5890935e9d5db2eec855f997715bbd94ac8fd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "015d53b7b812bfb0699808b2b27fe125c334905baef3e705fab92a8ddbcf42b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e491ac8938bfbf9459ed38991fc6b85709970249ff3e84c23884eadd2d611ef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b3c92e4da951d985d2ad8b87342552b821ce85fbfc5ed3e64d2d41463e7271"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb24f5d0d6a7efddf3d78a81ce84cecd92123e14e7d13dfed215d6da58db69d"
    sha256 cellar: :any,                 arm64_linux:   "2d3ca787d88e6eccbf2e2957a6912304a21d4d41a99aa7a8f742ee9579e2b4d7"
    sha256 cellar: :any,                 x86_64_linux:  "d86a669b36b4e54c7155f59298666a3438ed99cf627c3a75c0bbe23e438a691f"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
