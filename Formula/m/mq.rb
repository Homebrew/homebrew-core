class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.25.tar.gz"
  sha256 "e851a5d4289179cc7d74670e7a4dcb70682accebb3c2d35d6779c89a160fe94c"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d5c2c35e1aef534fc33f8d5e8ee86ee9e4ce425dff51931a288510e9705c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb2fced56c8f2758554b8222cbd7fb057cd306f695677cc0cd84a5c4530e2cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d527bae44becfa3b74f218bcefd7803caba6f90ad3d4f43f846d1c3d5073ca4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7322f040c909bbf48d3606ae94e08cc206a7685af29e0a473cf6e3d3dee75d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d37a59a7f55436669e23bddc08c0d25f9a0ebdb570f1cba926cdad6952ce964f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0355754c0580779769cd55102b326fe08f2a5c33f182a04ce036d4170b6ca3c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
