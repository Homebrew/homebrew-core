class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/40.0.0.tar.gz"
  sha256 "92e5ade859952bc79a3c68492803ce0af25a7332c78c4a0e1914da302d88b478"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9597a3f0a0b165193379c2a3d38503a981df1dfeaf6ff8d8c29c616f276c33f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9597a3f0a0b165193379c2a3d38503a981df1dfeaf6ff8d8c29c616f276c33f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9597a3f0a0b165193379c2a3d38503a981df1dfeaf6ff8d8c29c616f276c33f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3717c2e25ed32459307145a80bde8c884c05093875605cf893e8753c4eb8aa2a"
    sha256 cellar: :any,                 x86_64_linux:      "b2180d9e1aaf98016eb42a269edf861cacf77e504e33657e935ac4757604064b"
  end

  depends_on "go" => :build

  conflicts_with "fx-agent", because: "both install an `fx` binary"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
