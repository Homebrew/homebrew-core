class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.3.2.tar.gz"
  sha256 "f3b0dc83ded7d19f0f323f9fce6d8c6b6bed617b1d86a2b5d007bf1a98046212"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd66c20b2cce5ab686b9729058a0b81d9ff12ff2ca68be325e36b5525a131614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0134f81ad8303f62a999f8f12b1b1efc8eabd87f07d0ced0860ca26f84cb215b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb665fa96b99b048b6ac9eee66133b6b159e301ed6658de331ef1801e7323bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d05b2810018184aeb8239cc44f09c5000dc18267f50fbb3a71f4b2f2d363813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83e94432716935007318326e5be728c1c4fa69c482ff8f93f58ad6eda8116dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01120ef986121bd8c778b252c1c5cdaa154368862db717b71cb6812e5e2e15b1"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imessage-exporter --version")
    output = shell_output("#{bin}/imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration", output
  end
end
