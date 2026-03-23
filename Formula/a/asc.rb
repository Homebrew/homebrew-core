class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.45.3.tar.gz"
  sha256 "d35e4fca1b6145c5534a5c20b342ed90ed3c545218fb0ce72107629d2b52665b"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96148b25808536bad543707ba174f1aa358accac296ce7e68ee0602071bc510f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c305f3d6a54dfc7c207b88d9202afb4152382ae7031cc9aeac18911e737d4a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "610e16454a1b8a2bf7e6f480ab233a47679570a93663688ca7aa8b3f6aae1edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "acbbbded2bf15e4ebab717cbb630a49414994c1e0ab6f5764f4fe05e6a2b0bfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c02684e31f33317ab6dc5a9d47a9cf5d67fcb7ade5ff70c51e26292a2aee04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bad611b6be681fd962d9690e5563bfb7d6e03575557a968dd6989ef4a2156284"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
