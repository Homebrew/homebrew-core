class Code < Formula
  desc "Terminal coding agent"
  homepage "https://github.com/just-every/code"
  url "https://github.com/just-every/code/archive/refs/tags/v0.2.67.tar.gz"
  sha256 "db8d06e5414a27ee4462dd6179b681b9a99f01e7f7454bd93a6537be502a6f81"
  license "Apache-2.0"
  head "https://github.com/just-every/code.git", branch: "main"

  depends_on "rust" => :build

  def install
    ENV["CODE_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "codex-rs/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code --version")
  end
end
