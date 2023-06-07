class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "4bd3a24e34cacd595d80e04adce8786c2491850749aed2f534e07a2387573669"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb26977ddddf17bcf3d9591512deac360158ebc30fb66debb08fc740658440e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6077a98f466c08b8bf62cada9c540d8eabb377e86860eaa695e8b7cb5f997975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "902ad43280298b7f901a5ea321ee2d905ff163097d12a3b8006fb74b76aa9fbc"
    sha256 cellar: :any_skip_relocation, ventura:        "f66a1bae3a8774e18ca848aa7f4072018b1ee6870a6ddef543ea2e9e31cb43b0"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f9d81ed17b4c8ac612f1948e3b1479f315c521ab6d97c28bde1cf55fd0f712"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dd3b9c09a32bfc9347765ee47e225bbbc30191ae5144547d10cebe86350c2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86e25757756d23106c10c214930a09170c242b462d476780169bcf613617063f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"erd", "--completions")
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end
