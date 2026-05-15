class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "7a1c7962d4e33b5a80133119330bfc21b13ae805c0e7d2862d73c36ffac9fbb9"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ded41d13d8a6f36622607150d47235c6e508ce5d9bc2cecaf24519ce828f3506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded41d13d8a6f36622607150d47235c6e508ce5d9bc2cecaf24519ce828f3506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ded41d13d8a6f36622607150d47235c6e508ce5d9bc2cecaf24519ce828f3506"
    sha256 cellar: :any_skip_relocation, sonoma:        "be76fbedc938009d975403b07195b29d9d7436125e8b7c3a016f4cfeec94d8ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2057ca7d2e1c6edc7b0ab4c1092e6af1a3308537637fc77ebb350959d8b44903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e8c178d9bd76dc0267847d3b5570ad1096a0185b370827e7f260bbcef2dad2"
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
