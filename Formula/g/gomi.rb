class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "fd42c42f148a82ac9dc5b16c53dd8e2431397630d6a0ae788c2541e297326784"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f65ce65608b32def7274c0e37cdfd4173c767bfe48875cbea862dfa79edae182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ebe115f655c00e6755d3e0eae1208fe80ba957b51a291574b109268dd8d6bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebe115f655c00e6755d3e0eae1208fe80ba957b51a291574b109268dd8d6bcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ebe115f655c00e6755d3e0eae1208fe80ba957b51a291574b109268dd8d6bcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "706809943057038c5131a01c1593c401cacab6dfc2b1da6f77ba73d6c1f73b46"
    sha256 cellar: :any_skip_relocation, ventura:       "706809943057038c5131a01c1593c401cacab6dfc2b1da6f77ba73d6c1f73b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0306496b5a2c2f4e81d612a65680edab94d86a9712824c5be04e464e5d86d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1336b3d3bcb61d81006c1e8a491d3b83ca6b871d0323597a20187204160ad83b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
