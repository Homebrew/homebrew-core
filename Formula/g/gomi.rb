class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "27d4bfca8473a5c01c3ead075f2674b47b586b6de8afc7fb31ade1c01d7e5b8a"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fecaf395a97f00138d66db5f9ba75037e3c19a9d135cbd7d7cfa1da693fc0ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fecaf395a97f00138d66db5f9ba75037e3c19a9d135cbd7d7cfa1da693fc0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fecaf395a97f00138d66db5f9ba75037e3c19a9d135cbd7d7cfa1da693fc0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c0fd9e1636f7987981d0c1ecfb6bc5435a8d7cf907dcbd9a60a715a04d0301c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0a7fdcddc36e8a11c0e6201285913f4ec4a360b03dbbd525645157a295dd36"
    sha256 cellar: :any,                 x86_64_linux:  "0990e439fbb42af9fa3beb401a1540384f0b9e670a69665045352d835f1e1320"
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
