class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "fbb3a24fbbc753054f5a60b2aba59539c9b9f34df4400b05e566c78cf30b0a92"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364ca8a17218338aa2f167a05a98f1c7e1276c864d8fc9aef6b2232403cdac81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e2140687a0cb589a735913c857e8c8bc0d1d03467f3eb389cda0f3396010eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380acc85f4f896537e2636420ba5247bcdfedd3d68402458520fa2cc139dece5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9069e811457725a5048ba2346d7605325ad1f936d385eec43d5d5311b913f0"
    sha256 cellar: :any,                 arm64_linux:   "79e5aa5cd9b3bc97e06a2c38e6451919cc138f5c5424d1d908719fc6c79de8a7"
    sha256 cellar: :any,                 x86_64_linux:  "3537ee7aa635e7720638dc8112f99ddafb36af62af1b1cc0ba263faa5e6cefc0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
