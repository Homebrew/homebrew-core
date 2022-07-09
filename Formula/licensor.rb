class Licensor < Formula
  desc "Write licenses to stdout"
  homepage "https://github.com/raftario/licensor"
  url "https://github.com/raftario/licensor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d061ce9fd26d58b0c6ababa7acdaf35222a4407f0b5ea9c4b78f6835527611fd"
  license "MIT"
  head "https://github.com/raftario/licensor.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/licensor --version")

    assert_match "MIT License", shell_output("#{bin}/licensor MIT")
    assert_match "Bobby Tables", shell_output("#{bin}/licensor MIT 'Bobby Tables'")
  end
end
