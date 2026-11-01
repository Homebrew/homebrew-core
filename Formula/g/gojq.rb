class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.20",
      revision: "e7c14eca0339b4a122f9b293a114e267f8699f49"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f967ca6adea7be805164edec6f8dcefb754ea58e1ebd36593c403e4c77bc30fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f967ca6adea7be805164edec6f8dcefb754ea58e1ebd36593c403e4c77bc30fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f967ca6adea7be805164edec6f8dcefb754ea58e1ebd36593c403e4c77bc30fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4992a396bba6a4b57afc333e29f27470863d013dd62439918ccace00ba1f1eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a6e4eee50e5f1fcf56bf2ae7716cc07de2783ce61c4824921fc4bcde3660acbb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    revision = Utils.git_short_head
    ldflags = %W[-X github.com/itchyny/gojq/cli.revision=#{revision}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
