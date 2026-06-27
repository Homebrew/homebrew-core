class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.5.29.tar.gz"
  sha256 "5340a8825432c15819e129cc6dd36250bf672e9ed0d2505cb7233e6cf69828d8"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c6c5cd7aabcc533829b9ee017442e6c55388abc5d189753cb2a94437ac5ccc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd03f135ff9b32805d4332cff7b2d8a9c5688a46bec7cc2c07c10dcc2a1e84b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b3853284d86a7382b1c3d31475781cd9919fab73100a60c87bb095122e4dfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "226eb65565bbb87fd756b923fed761eba23935acd2f9609ffeeb870026117df8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41c858ae155ce44906bc504d93361cc2595948638e3d7cbe1fdcd7146b810a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e922a86bd4f9edf53e908775158d5de6a0918673da9ff4a02fa6bbb5eaea3e71"
  end

  depends_on "zig" => :build

  def install
    args = ["-Dversion=#{version}"]
    system "zig", "build", *args, *std_zig_args
  end

  service do
    run [opt_bin/"nullclaw", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullclaw --version")

    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
  end
end
